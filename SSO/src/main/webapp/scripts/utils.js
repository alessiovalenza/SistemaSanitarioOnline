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
        if (componentName === c.attr('id')){
            c.fadeIn(0);
        }else{
            c.fadeOut(0);
        }
    });
}

/*
 * chiama hide() su tutti i component
 */
function hideComponents(){
    components.forEach( (c) => c.hide())
}