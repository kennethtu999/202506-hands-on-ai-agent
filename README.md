# Lab 環境 建立

## 課程中使用的n8n workflow
- [demo1](workflow/demo.json)
- [demo2](workflow/demo.json)
- [mcp-service](workflow/mcp-service.json)

## podman 建立環境
使用以下指令建立 個lab環境

``` sh
# 建立 volume 
#podman volume rm n8n_data_lab07
podman volume create n8n_data_lab07


# 建立 n8n 容器
#podman stop n8n_lab07 && podman rm n8n_lab07
podman run -d --name n8n_lab07 \
  -p 10007:10007 \
  -v n8n_data_lab07:/home/node/.n8n \
  -e N8N_HOST="localhost" \
  -e N8N_PORT=10007 \
  -e N8N_PROTOCOL="http" \
  -e WEBHOOK_URL="https://public.domain/" \
  -e N8N_EDITOR_BASE_URL="https://public.domain/" \
  docker.n8n.io/n8nio/n8n
```

## conf.d目錄下的 Nginx Server 設定

``` sh
map $http_accept $rewrite_mf {
    default 0;
    ~*text/html 1;
}

server {
    server_name public.domain;

    location / {
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_buffering             off;
        gzip                        off;
        chunked_transfer_encoding   off;

	proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

    	proxy_pass http://127.0.0.1:10007;
    }

    listen 443 ssl; # managed by Certbot
}

server {
    if ($host = public.domain) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    server_name public.domain;
    return 404; # managed by Certbot

}
```

