function popup(id, name) {
    console.log("Opening popup for:", id);

    const container = document.getElementById("popup" + capitalize(id));

    container.innerHTML = `
        <div class="popupContent" onclick="event.stopPropagation()">
            
            <button class="closeBtn" onclick="closePopup('${id}', '${name}')">✕</button>

            <h3>${name}</h3>

            <iframe src="resultsPopup.html?id=${id}"></iframe>

        </div>
    `;

    container.style.display = "flex";

    setTimeout(() => {
        container.classList.add("active");
    }, 10);
}

function closePopup(id, name) {

    const container = document.getElementById("popup" + capitalize(id));

    container.classList.remove("active");

    setTimeout(() => {
        container.style.display = "none";
        container.innerHTML = "";
    }, 300);
}

function capitalize(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
}