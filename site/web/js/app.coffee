#
window.helpers =
    scrollTo: (val, duration, done) ->
        return if duration < 0
        return if window.scrollToWorking == true

        e = document.documentElement

        if e.scrollTop == 0
            t = e.scrollTop

            ++e.scrollTop

            if t+1 != e.scrollTop--
                e = document.body

        from = e.scrollTop
        to = val

        from = from.offsetTop if typeof from == "object"
        to = to.offsetTop if typeof to == "object"

        easeOutCuaic = (t) ->
            t--
            t*t*t+1

        scrollToX = (element, x1, x2, t, v, step, operacion, done1) ->
            return done1() if t < 0 || t > 1 || v <= 0

            element.scrollTop = x1 - (x1-x2) * operacion(t);
            t += v * step

            setTimeout(->
                scrollToX element, x1, x2, t, v, step, operacion, done1
            , step)

        window.scrollToWorking = true

        scrollToX e, from, to, 0, 1/duration, 20, easeOutCuaic, ->
            window.scrollToWorking = false
            done?()

    initMap: () ->
        mapEl = document.getElementById("lviv_office_map")
        return unless mapEl

        ukLatlng = new google.maps.LatLng(49.848817, 24.021466)

        ukMap = new google.maps.Map(mapEl,
          center: ukLatlng
          zoom: 16
          scrollwheel: false
          mapTypeId: google.maps.MapTypeId.ROADMAP
          styles: [
            stylers: [
              { hue: "#303842" }
              { saturation: -70 }
              { gamma: 1 }
            ]
          ]
        )

        ukMarker = new google.maps.Marker(
          position: ukLatlng
          map: ukMap
          title: "CURSOR Education"
        )

        new google.maps.Polyline({
          path: [
            {lat: 49.84848696, lng: 24.0202345}
            {lat: 49.84845583, lng: 24.02080715}
            {lat: 49.84883632, lng: 24.02088225}
            {lat: 49.84880865, lng: 24.02122155}
          ]
          geodesic: true
          strokeColor: '#303842'
          strokeOpacity: 1.0
          strokeWeight: 5
        }).setMap(ukMap)

        new google.maps.Polyline({
          path: [
            {lat: 49.84980656, lng: 24.02444959}
            {lat: 49.84822234, lng: 24.0243423}
            {lat: 49.84831574, lng: 24.02152061}
            {lat: 49.84878098, lng: 24.02158767}
            {lat: 49.84880778, lng: 24.02132615}
          ]
          geodesic: true
          strokeColor: '#CAA320'
          strokeOpacity: 1.0
          strokeWeight: 5
        }).setMap(ukMap)

    initTooltip: () ->
        tooltipEl = null

        #
        init = () =>
            getElements = -> document.getElementsByClassName 'tooltip'

            unless document.getElementById('tooltip')
                tooltipEl = document.createElement('div')
                tooltipEl.id = 'tooltip'

                document.body.appendChild tooltipEl

            for el in getElements()
                if el.hasAttribute('title')
                    el.setAttribute 'data-tooltip', el.getAttribute('title')
                    el.removeAttribute 'title'

                el.addEventListener 'mouseenter', show
                el.addEventListener 'mouseleave', hide
                el.addEventListener 'mousemove', setTooltipPos

        #
        show = ->
            tip = @getAttribute('data-tooltip')
            return unless tip

            document.getElementById('tooltip').innerHTML = tip
            document.getElementById('tooltip').style.width = tip.length * 7
            document.getElementById('tooltip').style.display = 'block'
            null

        #
        hide = ->
            document.getElementById('tooltip').style.display = 'none'
            null

        #
        setTooltipPos = (e) ->
            el = document.getElementById('tooltip')

            marginRight = 30

            _left = e.pageX
            _top = e.pageY

            if _left + el.clientWidth + marginRight > window.innerWidth
                _left = window.innerWidth - el.clientWidth - marginRight

            _top += 10
            _left += 5

            el.style.left = _left + 'px'
            el.style.top = _top + 'px'

            null

        #
        init()

    initScrollToTopEls: () ->
        for el in document.getElementsByClassName('go-to-top')
            do (el) ->
                el.onclick = (e) ->
                    e.preventDefault();

                    elementID = el.getAttribute('data-top');

                    if elementID
                        topValue = document.getElementById(elementID).offsetTop
                    else
                        topValue = 0

                    if el.hasAttribute('data-top-offset')
                        topOffset = parseInt el.getAttribute('data-top-offset')
                        topValue += topOffset

                    helpers.scrollHookMenuReset()
                    el.classList.add('selected')

                    helpers.scrollTo topValue, 1000, ->
                        helpers.scrollHookMenuReset()
                        el.classList.add('selected')

    scrollHook: ->
        helpers.scrollHookHeader()
        helpers.scrollHookMenu()
        helpers.scrollHookSections();

    scrollHookHeader: ->
        scroll = document.body.scrollTop

        headerMenuEl = document.getElementById('header-menu')

        if headerMenuEl.hasAttribute('data-animate-from-element')
            fromEl = document.getElementById(headerMenuEl.getAttribute('data-animate-from-element'))
            fromElOffset = Math.max(fromEl.offsetTop, 100)
        else
            fromElOffset = Math.max(headerMenuEl.getAttribute('data-animate-from'), 100)

        className = 'open'

        if scroll >= (fromElOffset - 50)
            headerMenuEl.classList.add(className)
        else
            headerMenuEl.classList.remove(className)

    scrollHookMenuReset: ->
        classSelected = 'selected'

        selectedEls = document.getElementById('menu').getElementsByClassName(classSelected)

        for selectedEl in selectedEls
            selectedEl.classList.remove(classSelected)

    scrollHookSections: ->
        scroll = document.body.scrollTop

        headerMenuEl = document.getElementById('header-menu')
        sectionsEls = document.getElementsByClassName('section')

        headerMenuElHeight = headerMenuEl.offsetHeight

        for i in [sectionsEls.length - 1..0] by -1
            sectionEl = sectionsEls[i]
            sectionElHeight = sectionEl.offsetTop

            if scroll + headerMenuElHeight > sectionElHeight
                _attrName = 'data-section-last'
                _attrValue = sectionEl.id
                _classValuePrefix = "visible-section"

                unless headerMenuEl.classList.contains _classValuePrefix
                    headerMenuEl.classList.add _classValuePrefix

                if headerMenuEl.hasAttribute(_attrName, _attrValue)
                    _oldAttrValue = headerMenuEl.getAttribute(_attrName, _attrValue)
                    
                    if _oldAttrValue != _attrValue
                        headerMenuEl.classList.remove _classValuePrefix + "-" + _oldAttrValue
                        headerMenuEl.setAttribute _attrName, _attrValue
                        headerMenuEl.classList.add _classValuePrefix + "-" + _attrValue

                else
                    headerMenuEl.setAttribute _attrName, _attrValue
                    headerMenuEl.classList.add _classValuePrefix + "-" + _attrValue

                break

    scrollHookMenu: ->
        scroll = document.body.scrollTop

        helpers.scrollHookMenuReset()

        classSelected = 'selected'

        menuEls = document.getElementById('menu').getElementsByTagName('a')
        offsetTopMin = -100

        offsetMin = null
        selectMenuEl = null

        for menuEl in menuEls
            dataTopEl = menuEl.getAttribute('data-top')

            if dataTopEl
                topEl = document.getElementById(dataTopEl)
                continue unless topEl

                topElOffset = scroll - (topEl.offsetTop + offsetTopMin)

                if topElOffset >= offsetTopMin
                    if offsetMin == null || offsetMin > Math.abs(topElOffset)
                        selectMenuEl = menuEl

        unless selectMenuEl?.classList.contains(classSelected)
            selectMenuEl?.classList.add(classSelected)

    parallax: ->
        els = [
            document.getElementById('header')
            document.getElementById('section-bg-inline')
        ]

        offsetY = scroll;
        offsetY = 0 if offsetY < 0;

        for el in els
            continue unless el

            isElVisible = scroll > -1
            isElVisible = isElVisible && scroll >= (el.offsetTop - el.offsetHeight)
            isElVisible = isElVisible && scroll <= (el.offsetTop + el.offsetHeight)

            if isElVisible
                bgOffset = offsetY - el.offsetTop
                el.style.backgroundPositionY = "#{bgOffset}px"

    ajax: (url, data, done) ->
        getXmlHttp = ->
            try
                xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
            catch e
                try
                    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                catch E
                    xmlhttp = false;

            if !xmlhttp and typeof XMLHttpRequest!='undefined'
                xmlhttp = new XMLHttpRequest()

            return xmlhttp

        xmlhttp = getXmlHttp()

        if data
            xmlhttp.open 'POST', url, true
        else
            xmlhttp.open 'POST', url, true

        xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded')

        xmlhttp.onreadystatechange = ->
            return if xmlhttp.readyState != 4

            if xmlhttp.status == 200
                done?(xmlhttp.responseText);
            else
                handleError(xmlhttp.statusText)

        xmlhttp.send(data);

    initSubmitForm: ->
        forms = document.getElementsByClassName 'light-form'

        for form in forms
            do (form) ->
                form.onsubmit = (e) ->
                    e.preventDefault()

                    disabledClass = 'disabled'

                    if form.classList.contains(disabledClass)
                        return false

                    form.classList.add(disabledClass);

                    inputs = form.getElementsByTagName('input')
                    params = []

                    for input in inputs
                        _name = input.name
                        _value = input.value
                        continue unless _name

                        params.push _name + "=" + encodeURIComponent(_value)

                    params = params.join('&')

                    helpers.ajax form.getAttribute('action'), params, (data) =>
                        if data == 'ok'
                            message = document.getElementById('message-success').innerText
                        else
                            message = document.getElementById('message-failed').innerText

                        alert(message)

                        form.classList.remove(disabledClass);

                        # clear
                        for input in inputs
                            continue unless input.name
                            input.value = ''

                    return false

    initAbTesting: ->
        return if location.hash?.indexOf('#ab-') == -1
        testId = location.hash.match(/#ab-(.+?)$/)?[1]

        tests =
            'landing1': ->
                slogan = 'Вчитися ніколи не пізно.<br>Ми навчаємо.'

                sloganEl = document.getElementsByClassName('slogan')[0].getElementsByTagName('span')[0]
                sloganEl.innerHTML = slogan

            'landing2': ->
                slogan = 'Навчайся разом з нами.<br>Львівська школа програмування.'

                sloganEl = document.getElementsByClassName('slogan')[0].getElementsByTagName('span')[0]
                sloganEl.innerHTML = slogan

        tests[testId]?()