export const fetchHelper = {
    get,
    post,
    put
};

function get(url) {
    const requestOptions = {
        method: 'GET',
        mode: 'same-origin',
        headers: { 'Accept': 'application/json' }
    };
    return fetch(url, requestOptions).then(handleResponse)
}

function post(url, body) {
    const requestOptions = {
        method: 'POST',
        mode: 'same-origin',
        headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
        body: JSON.stringify(body)
    };
    return fetch(url, requestOptions).then(handleResponse)
}

function put(url, body) {
    const requestOptions = {
        method: 'PUT',
        mode: 'same-origin',
        headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
        body: JSON.stringify(body)
    };
    return fetch(url, requestOptions).then(handleResponse)
}

// helper functions

function handleResponse(response) {
    return response.text().then(text => {
        const data = text && JSON.parse(text);

        if (!response.ok && response.status != 401) {
            const error = (data && data.message) || response.statusText;
            return Promise.reject(error);
        }

        data["statusCode"] = response.status;
        data["statusText"] = response.statusText;

        return data;
    });
}