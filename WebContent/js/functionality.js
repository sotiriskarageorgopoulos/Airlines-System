let counter = 0;
let clickCheckBoxes = 0;

const addMessageBox = (username,userId) => {
    if (counter === 0) {
        let messageBox = document.getElementById("message-box");
        messageBox.classList.add("mt-0");
        let form = document.createElement("form");
        form.method = "POST";
        form.style.marginTop = "0%";
        let p = document.createElement("p");
        p.innerText = "To: " + username;
        p.classList.add("mb-3");
        p.style.fontSize = "18px";
        let inputUserName = document.createElement("input");
        inputUserName.type = "hidden";
        inputUserName.name = "username";
        inputUserName.value = username;
		let inputUserId = document.createElement("input");
		inputUserId.type = "hidden";
		inputUserId.name = "userId";
		inputUserId.value = userId;
        let h2 = document.createElement("h2");
        h2.innerText = "Message";
        h2.classList.add("mb-3");
        h2.classList.add("insert-header");
        let labelSubject = document.createElement("label");
        labelSubject.innerText = "Subject: ";
        labelSubject.htmlFor = "subject";
        labelSubject.classList.add("form-label");
        let inputSubject = document.createElement("input");
        inputSubject.type = "text";
        inputSubject.name = "subject";
        inputSubject.id = "subject";
        inputSubject.classList.add("form-control");
        let labelMessage = document.createElement("label");
        labelMessage.htmlFor = "message";
        labelMessage.innerHTML = "Message: ";
        labelMessage.classList.add("form-label");
        let textareaMessage = document.createElement("textarea");
        textareaMessage.type = "text";
        textareaMessage.name = "message";
        textareaMessage.id = "message";
        textareaMessage.rows = "6";
        textareaMessage.placeholder = "Text here...";
        textareaMessage.classList.add("form-control");
        let btn = document.createElement("button");
        btn.type = "submit";
        btn.name = "message-btn";
        btn.innerText = "Send";
        btn.classList.add("mt-3");
        btn.classList.add("btn");
        btn.classList.add("btn-primary");
        messageBox.appendChild(form);
        form.appendChild(h2);
        form.appendChild(p);
        form.appendChild(labelSubject);
        form.appendChild(inputSubject);
        form.appendChild(labelMessage);
        form.appendChild(textareaMessage);
        form.appendChild(inputUserName);
		form.appendChild(inputUserId);
        form.appendChild(btn);
    }
    counter++;
}


const goToPage = (dest) => {
    window.location.href = dest;
}

const printTicket = (formNumber) => {
    let myWindow = window.open('', 'Ticket', 'width=1200,height=1200');
    let position = Number.parseInt(formNumber);
    let ticket = document.getElementsByTagName("form")[position];

    myWindow.document.write('<html><head><title>' + document.title + '</title>' +
        '</head>' + '<body style="padding: 2%;">');
    myWindow.document.write('<h1 style="margin-left:40%;">Ticket</h1>');
    myWindow.document.write('<div style="border: 2px solid black; margin-bottom: 2%;padding: 2%;">');

    for (let i = 2; i < ticket.childNodes.length; i++) {
        if (ticket.childNodes[i].innerText !== undefined && ticket.childNodes[i].innerText !== 'Print Ticket' &&
            ticket.childNodes[i].innerText !== 'Cancel Reservation' && ticket.childNodes[i].innerText !== 'Change Datetime') {
            console.log(ticket.childNodes[i].innerText)
            myWindow.document.write('<p style="font-size: 20px; font-weigth:500;">' + ticket.childNodes[i].innerText + '</p>');
        }
    }

    console.log(ticket);
    myWindow.document.write('</body>' + '</html>');
    myWindow.document.close();
    myWindow.focus();
    myWindow.print();
    myWindow.close();
}

const disableOrEnableCheckBoxes = () => {
    let checkboxes = document.getElementsByTagName("input");
    console.log(checkboxes);

    if (clickCheckBoxes % 2 == 0) {
        for (let i = 0; i < checkboxes.length; i++) {
            if (checkboxes[i].checked !== true) {
                checkboxes[i].disabled = true;
            }
        }
    } else {
        for (let i = 0; i < checkboxes.length; i++) checkboxes[i].disabled = false;
    }

    clickCheckBoxes++;
}