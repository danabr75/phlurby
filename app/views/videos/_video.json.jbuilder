json.extract! video, :id, :filename, :content_type, :file_contents, :created_at, :updated_at
json.url video_url(video, format: :json)
