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
    $(".componentControl").css("background-color", "#1e88e5");
    $(".componentControl").css("color", "#fff")
    $(".componentControl").data("focus",false);

    let tmp="#"+componentName+"Control"
    console.log(this)
    $(tmp).css("background-color", "#fff");
    $(tmp).css("color", "#7386D5");
    $(tmp).data("focus",true);


    $(".componentControl").mouseover(function () {
        if ($(this).data("focus") != true){
                $(this).css("background-color", "#CDCDCD");
                $(this).css("color", "#1e88e5");
        }
    }).mouseout(function () {
        if ($(this).data("focus") != true) {
            $(this).css("background-color", "#1e88e5");
            $(this).css("color", "#fff");
        }
    })


    components.forEach( (c) => {
        if (componentName === c.attr("id")){
            c.fadeIn(0);
        }else{
            c.fadeOut(0);
        }
    });

    $.ajax({
        url : baseUrl + "/section?selectedSection=" + componentName,
        type : "POST",
        contentType : false,
        processData : false,
        success: function() {

        },
        error: function(xhr, status, error) {
            console.log(xhr.responseText);
            //alert(xhr.responseText);
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
    if ($("#sidebarCollapse").is(':visible')) {
        $('.componentControl','.overlay').on('click.hideNavbar', function () {
            // hide sidebar
            //$('#sidebar').removeClass('active');
            // hide overlay
           // $('.overlay').removeClass('active');
            $( "#dismiss, .overlay" ).click() ;
        });
    }
    else {
            $(".componentControl").off("click.hideNavbar");
    }
}

function initSelect2Pazienti(idSelect, idProvincia, langCode, labelCerca) {
    $(idSelect).select2({
        placeholder: labelCerca,
        language: langCode,
        width: '100%',
        allowClear: true,
        ajax: {
            url: baseUrl + "/api/pazienti" + (idProvincia == null ? "" : "?idprovincia=" + idProvincia),
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
                console.log(xhr.responseText);
                //alert(xhr.responseText);
            }
        }
    });
}

/*
 * inizializza la select2 per la suggestion box <idSelect> dei pazienti del medico di base <idMedico>
 * <idSelect> deve iniziare con #
 */
function initSelect2PazientiByMB(idSelect, idMedico, langCode, labelCerca) {
    $(idSelect).select2({
        placeholder: labelCerca,
        language: langCode,
        width: '100%',
        allowClear: true,
        ajax: {
            url: baseUrl + "/api/medicibase/" + idMedico + "/pazienti?datericettavisita=false",
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
                console.log(xhr.responseText);
                //alert(xhr.responseText);
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
        width: '100%',
        allowClear: true,
        ajax: {
            url: baseUrl + "/api/general/" + tipoItem + "/",
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
                console.log(xhr.responseText);
                //alert(xhr.responseText);
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
    let urlFotoUtente = baseUrl + "/api/utenti/" + idUtente + "/foto";
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
            console.log(xhr.responseText);
            //alert(xhr.responseText);
        }
    });
}

function initAvatar(idUtente, avatarId, basePath, extension) {
    let urlFotoUtente = baseUrl + "/api/utenti/" + idUtente + "/foto";
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
            console.log(xhr.responseText);
            //alert(xhr.responseText);
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

function initUploadFoto(formId, idUtente, popupId, labelBtn) {
    $(formId).submit(function(e){
        loadingButton(popupId,labelLoadingButtons)
        e.preventDefault();
        let formData = new FormData($(formId)[0]);
        $.ajax({
            url : baseUrl + "/api/utenti/" + idUtente + "/foto",
            type : "POST",
            data : formData,
            contentType : false,
            processData : false,
            success: function() {
                successButton(popupId,labelSuccessButtons)
                //alert("Immagine aggiunta con successo!");
            },
            error: function(xhr, status, error) {
                console.log(xhr.responseText);
                errorButton(popupId,labelErrorButtons)
                //alert(xhr.responseText);
            }
        });
    });

    $("#fotoToUpload").click(function () {
        resetButton("#btnUploadFoto", labelBtn);
    });
}

function loadingButton(id,labelLoading) {
    const loadingText = '<i class="fa fa-circle-o-notch fa-spin"></i>'+labelLoadingButtons;//mettete qua le stringhe per la lingua
    let $this = $(id);
    $(id).css("background-color", "#1565c0");
    $(id).prop("disabled", true);

    if ($(id).html() !== loadingText) {
        $this.data('original-text', $(id).html());
        //$this.data('success-text', $("#btnPrescriviFarmaco").html(<i class="fas fa-exclamation-triangle"></i>));

        $this.html(loadingText);
    }
}

function resetButton(id, labelButton) {
    $(id).html(labelButton);
    $(id).css("background-color", "#1565c0");
    $(id).prop("disabled", false);
}

function successButton(id,labelSuccess) {
    const successText = '<i class="fas fa-check"></i>'+labelSuccessButtons;//mettete qua le stringhe per la lingua
    $(id).html(successText)
    $(id).css("background-color", "#4BB543");
}

function errorButton(id,labelError) {
    const errorText = '<i class="fas fa-exclamation-triangle"></i>'+labelErrorButtons;//mettete qua le stringhe per la lingua
    $(id).css("background-color", "#cc0000");
    $(id).html(errorText)
}

function initCambioPassword(formId, oldPwId, newPwId, ripetiPwId, idUtente, btnId, msgId, labelErrorPwVecchia, labelErrorMismatch, labelBtn) {
    document.getElementById(msgId).style.visibility = "hidden";
    $(formId).submit(function (event) {
        loadingButton(btnId,labelLoadingButtons);
        event.preventDefault();
        if($(newPwId).val() == $(ripetiPwId).val()) {
            let urlCambioPw = baseUrl + "/api/utenti/" + idUtente + "/password";
            let formData = "vecchiapassword=" + $(oldPwId).val() + "&nuovapassword=" + $(newPwId).val();
            $.ajax({
                url: urlCambioPw,
                type: "PUT",
                data: formData,
                success: function (data) {
                    $(".inputCambiaPassword").val("");
                    successButton(btnId,labelSuccessButtons);
                },
                complete: function () {
                },
                error: function (xhr, status, error) {
                    errorButton(btnId,labelErrorButtons);
                    $(".inputCambiaPassword").val("");
                    if (xhr.status == 401) {
                        document.getElementById(msgId).style.visibility ="visible";
                        document.getElementById(msgId).textContent = labelErrorPwVecchia;
                    } else {
                        //alert(xhr.responseText);
                        console.log(xhr.responseText);
                    }
                }
            });
        }
        else {
            document.getElementById(msgId).style.visibility ="visible";
            document.getElementById(msgId).textContent = labelErrorMismatch;
            errorButton(btnId,labelErrorButtons);
            $('.inputCambiaPassword').val("");
        }
    });

    $('.inputCambiaPassword').click(function () {
        document.getElementById(msgId).style.visibility ="hidden";
        document.getElementById(msgId).textContent = "";
        resetButton(btnId, labelBtn);
    });
    $('.inputCambiaPassword').on("input", function () {
        document.getElementById(msgId).style.visibility ="hidden";
        document.getElementById(msgId).textContent = "";
        resetButton(btnId, labelBtn);
    });
}

function setNomeProvincia(targetId, idProvincia) {
    $.ajax({
        url : baseUrl + "/api/general/province/" + idProvincia,
        type : "GET",
        contentType : false,
        processData : false,
        success: function(data) {
            document.getElementById(targetId).textContent = data.nome;
        },
        error: function(xhr, status, error) {
            console.log(xhr.responseText);
            document.getElementById(targetId).textContent = idProvincia;
        }
    });
}

function initFormSchedaPaz(basePathScheda, extension, fmtDateCode, urlLangDataTable) {
    $("#formScheda").submit(function(event){
        event.preventDefault();
        let pathCarouselPaz = basePathScheda + $('#idpazienteScheda').val() + "/";
        initCarousel($('#idpazienteScheda').val(), "carouselInnerPaziente", pathCarouselPaz, extension);

        $('#dataPazienteScheda').DataTable().destroy()
        let urlDataPaziente = baseUrl + "/api/pazienti/"+$('#idpazienteScheda').val();
        $('#dataPazienteScheda').DataTable( {
            "responsive": true,
            "autoWidth": false,
            "scrollX": false,
            "processing": false,
            "ordering": false,
            "paging": false,
            "searching": false,
            "serverSide": false,
            "info": false,
            "language": {
                "url": urlLangDataTable
            },
            "ajax": {
                "url": urlDataPaziente,
                "type":"GET",
                "dataSrc": function (json) {
                    let returnData = new Array();
                    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                    let dataNascita = new Date(json.dataNascita);
                    dataNascita=dataNascita.toLocaleDateString(fmtDateCode);
                    returnData.push({
                        'nome': json.nome,
                        'cognome': json.cognome,
                        'dataNascita': dataNascita,
                        'luogoNascita': json.luogoNascita,
                        'codiceFiscale': json.codiceFiscale,
                        'sesso': json.sesso,
                        'email': json.email
                    });
                    return returnData;
                },
                "error": function(xhr, status, error) {
                    console.log(xhr.responseText);
                    //alert(xhr.responseText);
                }
            },
            "columns": [
                { "data": "nome" },
                { "data": "cognome" },
                { "data": "dataNascita" },
                { "data": "luogoNascita" },
                { "data": "codiceFiscale"},
                { "data": "sesso" },
                { "data": "email" }
            ]
        } );

        $('#visiteBasePazienteScheda').DataTable().destroy()
        let urlVisiteBase = baseUrl + "/api/pazienti/"+$('#idpazienteScheda').val()+"/visitebase"
        let table = $('#visiteBasePazienteScheda').DataTable( {
            "autoWidth": false,
            "responsive": true,
            "processing": true,
            "scrollX": false,
            "ordering": true,
            "paging": true,
            "searching": true,
            "serverSide": false,
            "language": {
                "url": urlLangDataTable
            },
            "ajax": {
                "url": urlVisiteBase,
                "type":"GET",
                "dataSrc": function (json) {
                    let returnData = new Array();
                    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                    for(let i=0;i< json.length; i++) {
                        let erogazione = new Date(json[i].erogazione);
                        erogazione=erogazione.toLocaleDateString(fmtDateCode,options);
                        returnData.push({
                            'medicoBaseCognome': json[i].medicoBase.cognome,
                            'medicoBaseNome': json[i].medicoBase.nome,
                            'erogazione': erogazione,
                            'anamnesi': json[i].anamnesi
                        });
                    }
                    return returnData;
                },
                "error": function(xhr, status, error) {
                    console.log(xhr.responseText);
                    //alert(xhr.responseText);
                }
            },
            "columnDefs": [
                { className: "anamnesiColumn", targets: 3 }
            ],
            "columns": [
                { "data": "medicoBaseNome" },
                { "data": "medicoBaseCognome" },
                { "data": "erogazione" },
                { "data": "anamnesi" }
            ]
        } );
        $("#visiteBasePazienteScheda tbody").on("click", ".anamnesiColumn", function () {
            let data = table.row( this ).data();
            alert(data.anamnesi);
        } );

        $('#visiteSpecialisticheErogatePazienteScheda').DataTable().destroy()
        let urlVisiteSpacialisticheErogate = baseUrl + "/api/pazienti/"+$('#idpazienteScheda').val()+"/visitespecialistiche/?erogateonly=true&nonerogateonly=false"
        $('#visiteSpecialisticheErogatePazienteScheda').DataTable( {
            "autoWidth": false,
            "processing": true,
            "responsive": true,
            "scrollX": false,
            "ordering": true,
            "paging": true,
            "searching": true,
            "serverSide": false,
            "language": {
                "url": urlLangDataTable
            },
            "ajax": {
                "url": urlVisiteSpacialisticheErogate,
                "type":"GET",
                "dataSrc": function (json) {
                    let returnData = new Array();
                    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                    for(let i=0;i< json.length; i++) {
                        let prescrizione = new Date(json[i].prescrizione);
                        prescrizione=prescrizione.toLocaleDateString(fmtDateCode,options);
                        let erogazione = new Date(json[i].erogazione);
                        erogazione=erogazione.toLocaleDateString(fmtDateCode,options);
                        returnData.push({
                            'visitaNome': json[i].visita.nome,
                            'medicoSpecialistaCognome': json[i].medicoSpecialista.cognome,
                            'medicoSpecialistaNome': json[i].medicoSpecialista.nome,
                            'medicoBaseCognome': json[i].medicoBase.cognome,
                            'medicoBaseNome': json[i].medicoBase.nome,
                            'prescrizione': prescrizione,
                            'erogazione': erogazione,
                            'anamnesi': json[i].anamnesi
                        });
                    }
                    return returnData;
                },
                "error": function(xhr, status, error) {
                    console.log(xhr.responseText);
                    //alert(xhr.responseText);
                }
            },
            "columnDefs": [
                { className: "anamnesiColumn", targets: 7 }
            ],
            "columns": [
                { "data": "visitaNome" },
                { "data": "medicoSpecialistaNome" },
                { "data": "medicoSpecialistaCognome" },
                { "data": "medicoBaseNome" },
                { "data": "medicoBaseCognome" },
                { "data": "prescrizione" },
                { "data": "erogazione" },
                { "data": "anamnesi" }
            ]
        } );
        $("#visiteSpecialisticheErogatePazienteScheda tbody").on("click", ".anamnesiColumn", function () {
            let data = table.row( this ).data();
            alert(data.anamnesi);
        } );

        $('#visiteSpecialisticheNonErogatePazienteScheda').DataTable().destroy()
        let urlVisiteSpacialisticheNonErogate = baseUrl + "/api/pazienti/"+$('#idpazienteScheda').val()+"/visitespecialistiche/?erogateonly=false&nonerogateonly=true"
        $('#visiteSpecialisticheNonErogatePazienteScheda').DataTable( {
            "autoWidth": false,
            "responsive": true,
            "processing": true,
            "ordering": true,
            "scrollX": false,
            "paging": true,
            "searching": true,
            "serverSide": false,
            "language": {
                "url": urlLangDataTable
            },
            "ajax": {
                "url": urlVisiteSpacialisticheNonErogate,
                "type":"GET",
                "dataSrc": function (json) {
                    let returnData = new Array();
                    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                    for(let i=0;i< json.length; i++) {
                        let prescrizione = new Date(json[i].prescrizione);
                        prescrizione=prescrizione.toLocaleDateString(fmtDateCode,options);
                        returnData.push({
                            'visitaNome': json[i].visita.nome,
                            'medicoBaseCognome': json[i].medicoBase.cognome,
                            'medicoBaseNome': json[i].medicoBase.nome,
                            'prescrizione': prescrizione
                        });
                    }
                    return returnData;
                },
                "error": function(xhr, status, error) {
                    console.log(xhr.responseText);
                    //alert(xhr.responseText);
                }
            },
            "columns": [
                { "data": "visitaNome" },
                { "data": "medicoBaseNome" },
                { "data": "medicoBaseCognome" },
                { "data": "prescrizione" }
            ]
        } );

        $('#ricetteEvasePazienteScheda').DataTable().destroy()
        let urlRicetteEvase = baseUrl + "/api/pazienti/"+$('#idpazienteScheda').val()+"/ricette/?evaseonly=true&nonevaseonly=false"
        $('#ricetteEvasePazienteScheda').DataTable( {
            "autoWidth": false,
            "responsive": true,
            "processing": true,
            "ordering": true,
            "paging": true,
            "scrollX": false,
            "searching": true,
            "serverSide": false,
            "language": {
                "url": urlLangDataTable
            },
            "ajax": {
                "url": urlRicetteEvase,
                "type":"GET",
                "dataSrc": function (json) {
                    let returnData = new Array();
                    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                    for(let i=0;i< json.length; i++) {
                        let emissione = new Date(json[i].emissione);
                        emissione=emissione.toLocaleDateString(fmtDateCode,options);
                        let evasione = new Date(json[i].evasione);
                        evasione=evasione.toLocaleDateString(fmtDateCode,options);
                        returnData.push({
                            'farmacoNome': json[i].farmaco.nome,
                            'farmacoDescrizione': json[i].farmaco.descrizione,
                            'medicoBaseCognome': json[i].medicoBase.cognome,
                            'medicoBaseNome': json[i].medicoBase.nome,
                            'emissione': emissione,
                            'evasione': evasione
                        });
                    }
                    return returnData;
                },
                "error": function(xhr, status, error) {
                    console.log(xhr.responseText);
                    //alert(xhr.responseText);
                }
            },
            "columns": [
                { "data": "farmacoNome" },
                { "data": "farmacoDescrizione" },
                { "data": "medicoBaseNome" },
                { "data": "medicoBaseCognome" },
                { "data": "emissione" },
                { "data": "evasione" }
            ]
        } );

        $('#ricetteNonEvasePazienteScheda').DataTable().destroy()
        let urlRicetteNonEvase = baseUrl + "/api/pazienti/"+$('#idpazienteScheda').val()+"/ricette/?evaseonly=false&nonevaseonly=true"
        $('#ricetteNonEvasePazienteScheda').DataTable( {
            "autoWidth": false,
            "responsive": true,
            "processing": true,
            "ordering": true,
            "scrollX": false,
            "paging": true,
            "searching": true,
            "serverSide": false,
            "language": {
                "url": urlLangDataTable
            },
            "ajax": {
                "url": urlRicetteNonEvase,
                "type":"GET",
                "dataSrc": function (json) {
                    let returnData = new Array();
                    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                    for(let i=0;i< json.length; i++) {
                        let emissione = new Date(json[i].emissione);
                        emissione=emissione.toLocaleDateString(fmtDateCode,options);
                        returnData.push({
                            'farmacoNome': json[i].farmaco.nome,
                            'farmacoDescrizione': json[i].farmaco.descrizione,
                            'medicoBaseCognome': json[i].medicoBase.cognome,
                            'medicoBaseNome': json[i].medicoBase.nome,
                            'emissione': emissione
                        });
                    }
                    return returnData;
                },
                "error": function(xhr, status, error) {
                    console.log(xhr.responseText);
                    //alert(xhr.responseText);
                }
            },
            "columns": [
                { "data": "farmacoNome" },
                { "data": "farmacoDescrizione" },
                { "data": "medicoBaseNome" },
                { "data": "medicoBaseCognome" },
                { "data": "emissione" }
            ]
        } );

        $('#esamiErogatiPazienteScheda').DataTable().destroy()
        let urlEsamiErogati = baseUrl + "/api/pazienti/"+$('#idpazienteScheda').val()+"/esamiprescritti/?erogationly=true&nonerogationly=false"
        $('#esamiErogatiPazienteScheda').DataTable( {
            "autoWidth": false,
            "responsive": true,
            "processing": true,
            "ordering": true,
            "paging": true,
            "scrollX": false,
            "searching": true,
            "serverSide": false,
            "language": {
                "url": urlLangDataTable
            },
            "ajax": {
                "url": urlEsamiErogati,
                "type":"GET",
                "dataSrc": function (json) {
                    let returnData = new Array();
                    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                    for(let i=0;i< json.length; i++) {
                        let prescrizione = new Date(json[i].prescrizione);
                        prescrizione=prescrizione.toLocaleDateString(fmtDateCode,options);
                        let erogazione = new Date(json[i].erogazione);
                        erogazione=erogazione.toLocaleDateString(fmtDateCode,options);
                        returnData.push({
                            'nomeEsame': json[i].esame.nome,
                            'descrizioneEsame': json[i].esame.descrizione,
                            'cognomeMedicoBase': json[i].medicoBase == undefined ? "" : json[i].medicoBase.cognome,
                            'nomeMedicoBase': json[i].medicoBase == undefined ? "" : json[i].medicoBase.nome,
                            'prescrizione': prescrizione,
                            'erogazione': erogazione,
                            'esito': json[i].esito
                        });
                    }
                    return returnData;
                },
                "error": function(xhr, status, error) {
                    console.log(xhr.responseText);
                    //alert(xhr.responseText);
                }
            },
            "columnDefs": [
                { className: "anamnesiColumn", targets: 6 }
            ],
            "columns": [
                { "data": "nomeEsame" },
                { "data": "descrizioneEsame" },
                { "data": "nomeMedicoBase" },
                { "data": "cognomeMedicoBase" },
                { "data": "prescrizione" },
                { "data": "erogazione" },
                { "data": "esito" }
            ]
        } );
        $("#esamiErogatiPazienteScheda tbody").on("click", ".anamnesiColumn", function () {
            let data = table.row( this ).data();
            alert(data.esito);
        } );

        $('#esamiNonErogatiPazienteScheda').DataTable().destroy()
        let urlEsamiNonErogati = baseUrl + "/api/pazienti/"+$('#idpazienteScheda').val()+"/esamiprescritti/?erogationly=false&nonerogationly=true"
        $('#esamiNonErogatiPazienteScheda').DataTable( {
            "autoWidth": false,
            "responsive": true,
            "processing": true,
            "ordering": true,
            "scrollX": false,
            "paging": true,
            "searching": true,
            "serverSide": false,
            "language": {
                "url": urlLangDataTable
            },
            "ajax": {
                "url": urlEsamiNonErogati,
                "type":"GET",
                "dataSrc": function (json) {
                    let returnData = new Array();
                    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                    for(let i=0;i< json.length; i++) {
                        let prescrizione = new Date(json[i].prescrizione);
                        prescrizione=prescrizione.toLocaleDateString(fmtDateCode,options);
                        returnData.push({
                            'nomeEsame': json[i].esame.nome,
                            'descrizioneEsame': json[i].esame.descrizione,
                            'cognomeMedicoBase': json[i].medicoBase == undefined ? "" : json[i].medicoBase.cognome,
                            'nomeMedicoBase': json[i].medicoBase == undefined ? "" : json[i].medicoBase.nome,
                            'prescrizione': prescrizione
                        });
                    }
                    return returnData;
                },
                "error": function(xhr, status, error) {
                    console.log(xhr.responseText);
                    //alert(xhr.responseText);
                }
            },
            "columns": [
                { "data": "nomeEsame" },
                { "data": "descrizioneEsame" },
                { "data": "nomeMedicoBase" },
                { "data": "cognomeMedicoBase" },
                { "data": "prescrizione" }
            ]
        } );

        document.getElementById("schedaPaziente").style.display="block";
    });
}

function checkReport(fromDay, toDay, msgId, btnId, labelErrorReport, labelBtn) {
    if($(fromDay).val() <= $(toDay).val()) {
        document.getElementById(msgId).style.visibility ="hidden";
        document.getElementById(msgId).textContent = "";
        resetButton(btnId, labelBtn);
        return true;
    }
    else {
        document.getElementById(msgId).style.visibility ="visible";
        document.getElementById(msgId).textContent = labelErrorReport;
        errorButton(btnId,labelErrorButtons);
        return false;
    }
}

function initReport() {
    document.getElementById("messaggioReport").style.visibility ="hidden";
    let labelReport = document.getElementById("btnReport").innerHTML;
    $('.inputReport').on("click", function () {
        resetButton("#btnReport", labelReport);
        document.getElementById("messaggioReport").style.visibility ="hidden";
        document.getElementById("messaggioReport").textContent = "";
    });
}