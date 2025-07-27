<html>
<head>
    <title>Cool Time Display</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <p>If you see this line, that means your latest changes are automatically deployed into production by CodePipeline!</p>
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', 'Roboto', Arial, sans-serif;
            overflow: hidden;
        }
        
        .time-container {
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-radius: 30px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            padding: 3rem;
            text-align: center;
            max-width: 500px;
            width: 90%;
            position: relative;
            overflow: hidden;
        }
        
        .time-container::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: conic-gradient(from 0deg, transparent, rgba(255,255,255,0.1), transparent);
            animation: rotate 4s linear infinite;
            z-index: -1;
        }
        
        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .time-display {
            font-size: 4rem;
            font-weight: 700;
            color: white;
            text-shadow: 0 4px 8px rgba(0,0,0,0.3);
            margin-bottom: 1rem;
            font-family: 'Courier New', monospace;
            letter-spacing: 2px;
            animation: pulse 2s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.02); }
        }
        
        .date-display {
            font-size: 1.3rem;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 2rem;
            font-weight: 300;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .timezone {
            font-size: 1rem;
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 2rem;
            font-style: italic;
        }
        
        .time-details {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .detail-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 1rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: transform 0.3s ease;
        }
        
        .detail-card:hover {
            transform: translateY(-5px);
        }
        
        .detail-label {
            font-size: 0.8rem;
            color: rgba(255, 255, 255, 0.7);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.5rem;
        }
        
        .detail-value {
            font-size: 1.2rem;
            color: white;
            font-weight: 600;
        }
        
        .floating-particles {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            pointer-events: none;
            z-index: -1;
        }
        
        .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); opacity: 0; }
            50% { transform: translateY(-20px) rotate(180deg); opacity: 1; }
        }
        
        .particle:nth-child(1) { left: 10%; animation-delay: 0s; }
        .particle:nth-child(2) { left: 20%; animation-delay: 1s; }
        .particle:nth-child(3) { left: 30%; animation-delay: 2s; }
        .particle:nth-child(4) { left: 40%; animation-delay: 3s; }
        .particle:nth-child(5) { left: 50%; animation-delay: 4s; }
        .particle:nth-child(6) { left: 60%; animation-delay: 5s; }
        .particle:nth-child(7) { left: 70%; animation-delay: 0.5s; }
        .particle:nth-child(8) { left: 80%; animation-delay: 1.5s; }
        .particle:nth-child(9) { left: 90%; animation-delay: 2.5s; }
        
        @media (max-width: 600px) {
            .time-display { font-size: 2.5rem; }
            .date-display { font-size: 1rem; }
            .time-container { padding: 2rem 1.5rem; }
            .time-details { grid-template-columns: 1fr; gap: 0.5rem; }
        }
    </style>
</head>
<body>
    <div class="floating-particles">
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
    </div>
    
    <div class="time-container">
        <h1 class="time-display" id="timeDisplay">--:--:--</h1>
        <div class="date-display" id="dateDisplay">Loading...</div>
        <div class="timezone" id="timezone">Local Time</div>
        
        <div class="time-details">
            <div class="detail-card">
                <div class="detail-label">Day</div>
                <div class="detail-value" id="dayOfWeek">--</div>
            </div>
            <div class="detail-card">
                <div class="detail-label">Month</div>
                <div class="detail-value" id="month">--</div>
            </div>
            <div class="detail-card">
                <div class="detail-label">Year</div>
                <div class="detail-value" id="year">----</div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateTime() {
            const now = new Date();
            
            // Update time display
            const timeString = now.toLocaleTimeString('en-US', {
                hour12: false,
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            });
            document.getElementById('timeDisplay').textContent = timeString;
            
            // Update date display
            const dateString = now.toLocaleDateString('en-US', {
                weekday: 'long',
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });
            document.getElementById('dateDisplay').textContent = dateString;
            
            // Update timezone
            const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
            document.getElementById('timezone').textContent = timezone;
            
            // Update details
            document.getElementById('dayOfWeek').textContent = now.toLocaleDateString('en-US', { weekday: 'short' });
            document.getElementById('month').textContent = now.toLocaleDateString('en-US', { month: 'short' });
            document.getElementById('year').textContent = now.getFullYear();
        }
        
        // Update time immediately and then every second
        updateTime();
        setInterval(updateTime, 1000);
        
        // Add some interactive effects
        document.addEventListener('DOMContentLoaded', function() {
            const timeContainer = document.querySelector('.time-container');
            
            // Add mouse move effect
            document.addEventListener('mousemove', function(e) {
                const x = e.clientX / window.innerWidth;
                const y = e.clientY / window.innerHeight;
                
                timeContainer.style.transform = `perspective(1000px) rotateX(${(y - 0.5) * 5}deg) rotateY(${(x - 0.5) * 5}deg)`;
            });
            
            // Reset transform on mouse leave
            document.addEventListener('mouseleave', function() {
                timeContainer.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg)';
            });
        });
    </script>
</body>
</html>
