/*
 * Per 'component' intendo tutti i div che appartengono alla class 'component'.
 * 'components' è un set di div definito nella jsp (al momento solo in homeSSN).
 * Per integrare queste funzioni in tutte le altre jsp è sufficiente assicurarsi che tutti
 * i componenti appartengano alla classe 'component'. (In teoria)
 */

/*
 * aggiunge al set 'components' tutti i div che appartengono alla classe 'component'
 */
function populateComponents(){
    $('.component').each(function () {
        components.add($(this));
    });
}

/*
 * esegue il fadeIn del component che ha id=componentName e il fadeOut di tutti gli altri
 */
function showComponent(componentName){
    components.forEach( (c) => {
        if (componentName === c.attr("id")){
            c.fadeIn(0);
        }else{
            c.fadeOut(0);
        }
    });

    $.ajax({
        url : "http://localhost:8080/SSO_war_exploded/section?selectedSection=" + componentName,
        type : "POST",
        contentType : false,
        processData : false,
        success: function() {

        },
        error: function(xhr, status, error) {
            alert(xhr.responseText);
        }
    });
}

/*
 * chiama hide() su tutti i component
 */
function hideComponents(){
    components.forEach( (c) => c.hide());
}

function manageNavbar() {
    if ($("#sidebarCollapse").is(':visible')){
        $('.componentControl','.overlay').on('click.hideNavbar', function () {
            // hide sidebar
            //$('#sidebar').removeClass('active');
            // hide overlay
           // $('.overlay').removeClass('active');
            $( "#dismiss, .overlay" ).click() ;
        });
    }else{
            $(".componentControl").off("click.hideNavbar");
        }
    }

/*
 * inizializza la select2 per la suggestion box <idSelect> dei pazienti del medico di base <idMedico>
 * <idSelect> deve iniziare con #
 */
function initSelect2PazientiByMB(idSelect, idMedico, langCode, labelCerca) {
    $(idSelect).select2({
        placeholder: labelCerca,
        language: langCode,
        width: 300,
        allowClear: true,
        ajax: {
            url: "http://localhost:8080/SSO_war_exploded/api/medicibase/" + idMedico + "/pazienti?datericettavisita=false",
            datatype: "json",
            data: function (params) {
                var query = {
                    term: params.term,
                    type: 'public',
                    page: params.page || 1
                }
                return query;
            },
            processResults: function (data) {
                var myResults = [];
                $.each(data, function (index, item) {
                    myResults.push({
                        'id': item.id,
                        'text': item.nome+" "+item.cognome
                    });
                });
                return {
                    results: myResults
                };
            },
            error: function(xhr, status, error) {
                alert(xhr.responseText);
            }
        }
    });
}

/*
 * inizializza la select2 per la suggestion box <idSelect> dei elementi <tipoItem> (farmaci, esami, visite)
 * <idSelect> deve iniziare con #
 */
function initSelect2General(tipoItem, idSelect, langCode, labelCerca) {
    $(idSelect).select2({
        placeholder: labelCerca,
        language: langCode,
        width: 300,
        allowClear: true,
        ajax: {
            url: "http://localhost:8080/SSO_war_exploded/api/general/" + tipoItem + "/",
            datatype: "json",
            data: function (params) {
                var query = {
                    term: params.term,
                    type: 'public',
                    page: params.page || 1
                }
                return query;
            },
            processResults: function (data) {
                var myResults = [];
                $.each(data, function (index, item) {
                    myResults.push({
                        'id': item.id,
                        'text': item.nome
                    });
                });
                return {
                    results: myResults
                };
            },
            error: function(xhr, status, error) {
                alert(xhr.responseText);
            }
        }
    });
}

function appendImages(imagesIDs, carouselId, basePath, extension) {
    document.getElementById(carouselId).innerHTML = "";

    for (let i=0; i < imagesIDs.length; i++){
        let idImg = String(i) + "_" + carouselId+ "_img";
        let idSlide = String(i) + "_" + carouselId+ "_slide";

        let img= document.getElementById(idImg) === null ? document.createElement("img"): document.getElementById(idImg);
        let slide= document.getElementById(idSlide) === null ? document.createElement("slide"): document.getElementById(idSlide);

        img.id = idImg;
        slide.id = idSlide;

        if (i === 0) {
            slide.className="carousel-item active"
        }else{
            slide.className="carousel-item"
        }

        img.src = basePath + imagesIDs[i] + extension;
        //console.log(img.src);
        img.style.width="100%";
        //console.log(img);
        document.body.appendChild(slide);
        document.getElementById(slide.id).appendChild(img);
        //console.log(slide.id);
        document.getElementById(carouselId).appendChild(slide);
        //console.log("fatta slide");
    }
}

function initCarousel(idUtente, carouselId, basePath, extension) {
    let urlFotoUtente = "http://localhost:8080/SSO_war_exploded/api/utenti/" + idUtente + "/foto";
    $.ajax({
        url : urlFotoUtente,
        type: "GET",
        success: function (data) {
            let imagesIDs = [];
            for(let i = 0; i < data.length; i++) {
                imagesIDs[i] = data[i].id;
            }
            appendImages(imagesIDs, carouselId, basePath, extension);
        },
        error: function(xhr, status, error) {
            alert(xhr.responseText);
        }
    });
}

function initAvatar(idUtente, avatarId, basePath, extension) {
    let urlFotoUtente = "http://localhost:8080/SSO_war_exploded/api/utenti/" + idUtente + "/foto";
    $.ajax({
        url : urlFotoUtente,
        type: "GET",
        success: function (data) {
            let maxI = -1;
            let maxDate = new Date("1970/1/1").getTime();

            for(let i = 0; i < data.length; i++) {
                let tempTime = (new Date(data[i].caricamento)).getTime();
                if(tempTime > maxDate) {
                    maxDate = tempTime;
                    maxI = i;
                }
            }
            let img = document.getElementById(avatarId);
            img.src = basePath + data[maxI].id + extension;
        },
        error: function(xhr, status, error) {
            alert(xhr.responseText);
        }
    });
}

function fileValidation(fotoId, buttonId, labelEstensioneAlert){
    let fileInput = document.getElementById(fotoId);
    let filePath = fileInput.value;
    const allowedExtensions = /(\.jpg|\.jpeg)$/i;
    if(!allowedExtensions.exec(filePath)){
        alert(labelEstensioneAlert);
        fileInput.value = null;
        return false;
    } else {
        document.getElementById(buttonId).disabled = false;
    }
}

function initUploadFoto(formId, idUtente, popupId) {
    $(formId).submit(function(e){
        e.preventDefault();
        let formData = new FormData($(formId)[0]);
        $.ajax({
            url : "/SSO_war_exploded/api/utenti/" + idUtente + "/foto",
            type : "POST",
            data : formData,
            contentType : false,
            processData : false,
            success: function() {
                alert("Immagine aggiunta con successo!");
            },
            error: function(xhr, status, error) {
                alert(xhr.responseText);
            }
        });
    });
}




function loadingButton(id) {
    const loadingText = '<i class="fa fa-circle-o-notch fa-spin"></i> loading...';//mettete qua le stringhe per la lingua
    let $this = $(id);
    $(id).css("background-color", "#1565c0");

    if ($(id).html() !== loadingText) {
        $this.data('original-text', $(id).html());
        //$this.data('success-text', $("#btnPrescriviFarmaco").html(<i class="fas fa-exclamation-triangle"></i>));

        $this.html(loadingText);
    }
}
function successButton(id) {
    const successText = '<i class="fas fa-check"></i> success';//mettete qua le stringhe per la lingua
    $(id).html(successText)
    $(id).css("background-color", "#4BB543");
}
function errorButton(id) {
    const errorText = '<i class="fas fa-exclamation-triangle"></i> error';//mettete qua le stringhe per la lingua
    $(id).css("background-color", "#cc0000");
    $(id).html(errorText)
}