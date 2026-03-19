function popup(id, name) {
    console.log("Opening popup for:", id);

    const container = document.getElementById("popupCorhyn");

    container.innerHTML = `
        <div class="popupContent" onclick="event.stopPropagation()">
            
            <button class="closeBtn" onclick="closePopup('corhyn', 'Brother Corhyn')">✕</button>

            <h3>Brother Corhyn</h3>

            <iframe src="resultsPopup.html?id=corhyn"></iframe>

        </div>
    `;

    container.style.display = "flex";

    setTimeout(() => {
        container.classList.add("active");
    }, 10);
}

function closePopup(id, name) {

    const container = document.getElementById("popupCorhyn");

    container.classList.remove("active");

    setTimeout(() => {
        container.style.display = "none";
        container.innerHTML = "";
    }, 300);
}