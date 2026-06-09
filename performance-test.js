import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
    vus: 10,
    duration: "1m",
    thresholds: {
        http_req_failed: ["rate<0.05"],
        http_req_duration: ["p(95)<1000"],
    },
};

const BASE_URL = "http://localhost:8081/api";
const TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo2LCJlbWFpbCI6ImFyc2VuMTIzMTIzQGdtYWlsLmNvbSIsInVzZXJuYW1lIjoiYXJzZW4xMjMiLCJzdWIiOiI2IiwiZXhwIjoxNzgwMTI5MDk4LCJpYXQiOjE3ODAxMjgxOTh9.10UWBB-Gz8oFBd9_cTLrxqJp16ELY4s_3FUyOdCR48g";

export default function () {
    const authHeaders = {
        headers: {
            Authorization: `Bearer ${TOKEN}`,
            "Content-Type": "application/json",
        },
    };

    const meRes = http.get(`${BASE_URL}/auth/me`, authHeaders);
    check(meRes, { "me status is 200": (r) => r.status === 200 });

    const topicsRes = http.get(`${BASE_URL}/content/topics?lang=ru`, authHeaders);
    check(topicsRes, { "topics status is 200": (r) => r.status === 200 });

    const recommendationsRes = http.get(
        `${BASE_URL}/adaptation/recommendations/home?lang=ru`,
        authHeaders
    );
    check(recommendationsRes, {
        "recommendations status is 200": (r) => r.status === 200,
    });

    const learningMapRes = http.get(
        `${BASE_URL}/adaptation/learning-map?lang=ru`,
        authHeaders
    );
    check(learningMapRes, {
        "learning map status is 200": (r) => r.status === 200,
    });

    sleep(1);
}