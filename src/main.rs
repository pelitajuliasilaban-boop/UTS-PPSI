use axum::{routing::get, Json, Router};
use serde_json::{json, Value};
use tower_http::services::ServeDir;

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();

    let app = Router::new()
        .route("/api/health", get(health))
        .fallback_service(ServeDir::new("public"));

    let port = std::env::var("PORT").unwrap_or_else(|_| "3000".to_string());
    let addr = format!("0.0.0.0:{port}");
    let listener = tokio::net::TcpListener::bind(&addr).await.unwrap();
    println!("Taput Wisata Pass berjalan di http://localhost:{port}");
    axum::serve(listener, app).await.unwrap();
}

async fn health() -> Json<Value> {
    Json(json!({ "status": "ok", "app": "taput-wisata-pass" }))
}
