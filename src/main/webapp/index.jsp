<html>
<head>
    <title>Mini Weather Dashboard</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #4f8cff 0%, #a6e1fa 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', 'Roboto', Arial, sans-serif;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.25);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.18);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            max-width: 420px;
            margin: 2rem auto;
            padding: 2.5rem 2rem 2rem 2rem;
            transition: box-shadow 0.3s;
        }
        .glass-card:hover {
            box-shadow: 0 12px 40px 0 rgba(31, 38, 135, 0.25);
        }
        .weather-icon {
            width: 100px;
            height: 100px;
            filter: drop-shadow(0 2px 8px rgba(0,0,0,0.12));
            margin-bottom: 0.5rem;
            animation: popIn 0.7s cubic-bezier(.68,-0.55,.27,1.55);
        }
        @keyframes popIn {
            0% { transform: scale(0.7); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }
        .search-bar {
            background: rgba(255,255,255,0.7);
            border-radius: 12px;
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            font-size: 1.1rem;
        }
        .search-bar:focus {
            outline: none;
            box-shadow: 0 0 0 2px #4f8cff33;
        }
        .btn-primary {
            background: linear-gradient(90deg, #4f8cff 0%, #6fd6ff 100%);
            border: none;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 8px rgba(79,140,255,0.10);
        }
        .btn-primary:hover {
            background: linear-gradient(90deg, #3a6fd8 0%, #4f8cff 100%);
        }
        .weather-details {
            font-size: 1.1rem;
            margin-top: 1rem;
        }
        .weather-details strong {
            color: #4f8cff;
        }
        .city-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3a4a;
            margin-bottom: 0.2rem;
        }
        .weather-desc {
            font-size: 1.1rem;
            color: #4f8cff;
            margin-bottom: 0.5rem;
            text-transform: capitalize;
        }
        .fade-in {
            animation: fadeIn 0.7s;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @media (max-width: 600px) {
            .glass-card { padding: 1.5rem 0.5rem; }
            .weather-icon { width: 70px; height: 70px; }
        }
    </style>
</head>
<body>
<div class="glass-card">
    <h2 class="mb-4 text-center fw-bold" style="color:#4f8cff; letter-spacing:1px;">Mini Weather Dashboard</h2>
    <form id="weatherForm" class="mb-4 d-flex gap-2">
        <input type="text" id="cityInput" class="form-control search-bar" placeholder="Enter city name" required autofocus>
        <button type="submit" class="btn btn-primary px-4">Search</button>
    </form>
    <div id="weatherResult" class="text-center fade-in" style="display:none;">
        <div class="city-title" id="cityName"></div>
        <img id="weatherIcon" class="weather-icon" src="" alt="Weather Icon"/>
        <div id="weatherDesc" class="weather-desc"></div>
        <div class="weather-details">
            <div><strong>Temperature:</strong> <span id="temperature"></span>°C</div>
            <div><strong>Humidity:</strong> <span id="humidity"></span>%</div>
        </div>
    </div>
    <div id="errorMsg" class="alert alert-danger mt-3 fade-in" style="display:none;"></div>
    <div class="text-center mt-4" style="font-size:0.95rem;color:#7a8ca3;">Powered by <a href="https://openweathermap.org/" target="_blank" style="color:#4f8cff;text-decoration:none;">OpenWeatherMap</a></div>
</div>
<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
const apiKey = 'b924f0707e9a57c1fec39aba9fec4df3'; // <-- Replace with your OpenWeatherMap API key
const form = document.getElementById('weatherForm');
const cityInput = document.getElementById('cityInput');
const weatherResult = document.getElementById('weatherResult');
const cityName = document.getElementById('cityName');
const weatherIcon = document.getElementById('weatherIcon');
const weatherDesc = document.getElementById('weatherDesc');
const temperature = document.getElementById('temperature');
const humidity = document.getElementById('humidity');
const errorMsg = document.getElementById('errorMsg');

form.addEventListener('submit', async function(e) {
    e.preventDefault();
    const city = cityInput.value.trim();
    if (!city) return;
    weatherResult.style.display = 'none';
    errorMsg.style.display = 'none';
    try {
        const res = await fetch(`https://api.openweathermap.org/data/2.5/weather?q=${encodeURIComponent(city)}&appid=${apiKey}&units=metric`);
        if (!res.ok) throw new Error('City not found');
        const data = await res.json();
        cityName.textContent = `${data.name}, ${data.sys.country}`;
        weatherIcon.src = `https://openweathermap.org/img/wn/${data.weather[0].icon}@4x.png`;
        weatherIcon.alt = data.weather[0].description;
        weatherDesc.textContent = data.weather[0].main + ' - ' + data.weather[0].description;
        temperature.textContent = Math.round(data.main.temp);
        humidity.textContent = data.main.humidity;
        weatherResult.style.display = 'block';
        weatherResult.classList.remove('fade-in');
        void weatherResult.offsetWidth; // trigger reflow for animation
        weatherResult.classList.add('fade-in');
    } catch (err) {
        errorMsg.textContent = err.message;
        errorMsg.style.display = 'block';
        errorMsg.classList.remove('fade-in');
        void errorMsg.offsetWidth;
        errorMsg.classList.add('fade-in');
    }
});
</script>
</body>
</html>
