# script

# Build and push it to Artifact Registry (e.g, send-weather)
gcloud builds submit \
  --tag europe-west2-docker.pkg.dev/project-c671eb5f-7ad5-49a8-9d9/cloud-run-source-deploy/send-weather
gcloud run jobs create send-weather \
  --image europe-west2-docker.pkg.dev/project-c671eb5f-7ad5-49a8-9d9/cloud-run-source-deploy/send-weather \
  --region europe-west2 \
  --set-env-vars user=887274455,city=reading,APPSERVER_URL=https://appserver-320740736344.europe-west2.run.app,BOT_URL=https://bot-320740736344.europe-west2.run.app
gcloud scheduler jobs create http send-weather-schedule \
  --location=europe-west2 \
  --schedule="30 06 * * 1-5" \
  --uri="https://europe-west2-run.googleapis.com/apis/run.googleapis.com/v1/projects/project-c671eb5f-7ad5-49a8-9d9/locations/europe-west2/jobs/send-weather:run" \
  --http-method=POST \
  --oauth-service-account-email="scheduler-send-index@project-c671eb5f-7ad5-49a8-9d9.iam.gserviceaccount.com"

# test locally
docker run --rm \
  -e APPSERVER_URL="your-appserver-url" \
  -e BOT_URL="your-bot-url" \
  -e USERID="1234" \
  europe-west2-docker.pkg.dev/project-c671eb5f-7ad5-49a8-9d9/cloud-run-source-deploy/send-index
