<!DOCTYPE html>
<html>
<head>
    <title>AI Car Advisor</title>
    <style>
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #3498db;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
    <script>
        function askAI() {
            let question = document.getElementById("question").value;
            let context  = document.getElementById("context").value;
            
            // Show loading spinner and clear previous response
            document.getElementById("answer").innerHTML = '<div class="loading"></div> Loading AI response...';

            fetch("aiCompare", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "question=" + encodeURIComponent(question) +
                      "&context=" + encodeURIComponent(context)
            })
            .then(res => res.json())
            .then(data => {
                document.getElementById("answer").innerText = data.answer;
            })
            .catch(error => {
                document.getElementById("answer").innerHTML = "Error: " + error.message;
            });
        }
    </script>
</head>
<body>
    <h2>AI Car Advisor</h2>

    <textarea id="context" placeholder="Car details or list of cars…" rows="4" cols="50"></textarea><br><br>

    <textarea id="question" placeholder="Your question…" rows="3" cols="50"></textarea><br><br>

    <button onclick="askAI()">Ask AI</button>

    <h3>AI Response:</h3>
    <div id="answer" style="white-space: pre-wrap;"></div>

</body>
</html>
