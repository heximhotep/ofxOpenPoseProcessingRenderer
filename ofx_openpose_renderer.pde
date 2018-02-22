class SceneSequence
{
  int sceneIndex = 0;
  int numScenes;
  int imageWidth, imageHeight;
  String poseModel;
  JSONObject[][] poses;
  public SceneSequence(JSONArray baseJSON)
  {
    JSONObject baseObj = baseJSON.getJSONObject(0);
    numScenes = baseObj.getInt("numScenes");
    poses = new JSONObject[numScenes][];
    imageWidth = baseObj.getInt("imageWidth");
    imageHeight = baseObj.getInt("imageHeight");
    poseModel = baseObj.getString("poseModel");
    for(int sceneIndex = 0; sceneIndex < numScenes; sceneIndex++)
    {
      JSONObject scene = baseObj.getJSONObject("" + sceneIndex);
      int numPoses = scene.getInt("numPoses");
      poses[sceneIndex] = new JSONObject[numPoses];
      for(int poseIndex = 0; poseIndex < numPoses; poseIndex++)
      {
        JSONObject pose = scene.getJSONObject("" + poseIndex);
        poses[sceneIndex][poseIndex] = pose;
      }
    }
  }
  public void drawFrame()
  {
    JSONObject[] scene = poses[sceneIndex];
    for(int i = 0; i < scene.length; i++)
    {
      JSONObject pose = scene[i];
      println(poseModel);
      if(poseModel.equals("COCO"))
        drawCOCOPose(pose);
      else
        drawMPIPose(pose);
    }
    sceneIndex++;
    if(sceneIndex >= numScenes)
      sceneIndex = 0;
  }
}

void connectJoints(JSONObject pose, String joint0, String joint1)
{
  JSONArray pt0 = pose.getJSONArray(joint0);
  JSONArray pt1 = pose.getJSONArray(joint1);
  float x0 = pt0.getFloat(0);
  float y0 = pt0.getFloat(1);
  float x1 = pt1.getFloat(0);
  float y1 = pt1.getFloat(1);
  if((x0 != 0) && (y0 != 0) && (x1 != 0) && (y1 != 0))
    line(x0, y0, x1, y1);
}

void drawMPIPose(JSONObject pose)
{
  connectJoints(pose, "head", "neck");
  connectJoints(pose, "neck", "left_shoulder");
  connectJoints(pose, "neck", "right_shoulder");
  connectJoints(pose, "neck", "left_hip");
  connectJoints(pose, "neck", "right_hip");
  connectJoints(pose, "left_shoulder", "left_elbow");
  connectJoints(pose, "left_elbow", "left_hand");
  connectJoints(pose, "right_shoulder", "right_elbow");
  connectJoints(pose, "right_elbow", "right_hand");
  connectJoints(pose, "left_hip", "left_knee");
  connectJoints(pose, "left_knee", "left_foot");
  connectJoints(pose, "right_hip", "right_knee");
  connectJoints(pose, "right_knee", "right_foot");
}

void drawCOCOPose(JSONObject pose)
{
  connectJoints(pose, "left_eye", "nose");
  connectJoints(pose, "right_eye", "nose");
  connectJoints(pose, "left_ear", "left_eye");
  connectJoints(pose, "right_ear", "right_eye");
  connectJoints(pose, "nose", "neck");
  connectJoints(pose, "neck", "left_shoulder");
  connectJoints(pose, "left_shoulder", "left_elbow");
  connectJoints(pose, "left_elbow", "left_wrist");
  connectJoints(pose, "neck", "right_shoulder");
  connectJoints(pose, "right_shoulder", "right_elbow");
  connectJoints(pose, "right_elbow", "right_wrist");
  connectJoints(pose, "neck", "left_hip");
  connectJoints(pose, "left_hip", "left_knee");
  connectJoints(pose, "left_knee", "left_foot");
  connectJoints(pose, "neck", "right_hip");
  connectJoints(pose, "right_hip", "right_knee");
  connectJoints(pose, "right_knee", "right_foot");
}

JSONArray baseJSON;
SceneSequence sequence;

void setup()
{
  size(1280, 740);
  stroke(255);
  baseJSON = loadJSONArray("output.json");
  sequence = new SceneSequence(baseJSON);
}

void draw()
{
  background(0);
  sequence.drawFrame();
}