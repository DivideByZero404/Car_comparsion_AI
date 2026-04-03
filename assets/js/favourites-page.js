// GLOBAL ALERT MODAL
const alertOverlay = document.getElementById("globalAlertOverlay");
const alertTitle = document.getElementById("alertTitle");
const alertMessage = document.getElementById("alertMessage");
const alertOkBtn = document.getElementById("alertOkBtn");

function showAlertDialog(title, message) {
  if (!alertOverlay) return;

  if (alertTitle) alertTitle.textContent = title || "Notification";
  if (alertMessage) alertMessage.textContent = message || "";

  alertOverlay.classList.add("active");
}

if (alertOkBtn && alertOverlay) {
  alertOkBtn.addEventListener("click", () => {
    alertOverlay.classList.remove("active");
  });

  alertOverlay.addEventListener("click", (e) => {
    if (e.target === alertOverlay) {
      alertOverlay.classList.remove("active");
    }
  });
}

// helper to update badge
function updateFavBadge(count) {
  const badge = document.querySelector(".fav-count-badge");
  if (badge && typeof count === "number") {
    badge.textContent = count;
  }
}

// FAVOURITES PAGE: REMOVE ONE
document.addEventListener("click", function (e) {
  if (e.target.matches(".btn-remove") || e.target.matches(".fav-heart-btn")) {
    const card = e.target.closest(".fav-card");
    if (!card) return;

    const modelId = card.getAttribute("data-model-id");
    if (!modelId) return;

    removeFavourite(card, modelId);
  }
});

function removeFavourite(card, modelId) {
  fetch("remove-favourite", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: "modelId=" + encodeURIComponent(modelId),
  })
    .then((res) => res.json())
    .then((data) => {
      if (data.status === "ok") {
        card.classList.add("removing");
        setTimeout(() => {
          card.remove();
          if (!document.querySelector(".fav-card")) {
            window.location.reload();
          }
        }, 200);

        if (typeof data.count === "number") {
          updateFavBadge(data.count);
        }
      } else {
        showAlertDialog("Oops", "Could not remove from favourites.");
      }
    })
    .catch(() => {
      showAlertDialog("Error", "Network error while removing favourite.");
    });
}

// CLEAR ALL
const clearAllBtn = document.getElementById("clearAllBtn");

if (clearAllBtn) {
  clearAllBtn.addEventListener("click", () => {
    fetch("clear-favourites", {
      method: "POST",
    })
      .then((res) => res.json())
      .then((data) => {
        if (data.status === "ok") {
          document
            .querySelectorAll(".fav-card")
            .forEach((card) => card.classList.add("removing"));

          setTimeout(() => {
            window.location.reload();
          }, 220);

          if (typeof data.count === "number") {
            updateFavBadge(data.count);
          }
        } else {
          showAlertDialog(
            "Could not clear",
            "Something went wrong while clearing favourites."
          );
        }
      })
      .catch(() => {
        showAlertDialog(
          "Network error",
          "Please try clearing favourites again."
        );
      });
  });
}
