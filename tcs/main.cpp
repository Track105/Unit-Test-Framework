#include <cstdio>
#include <vector>
#include <cmath>
#include <iostream>
#include <algorithm>

class Point {
protected:
    friend class Point2D;
    friend class Point3D;
    friend class Point4D;
    std::vector<double> mCoordinates;
    double mDistance;
public:
    virtual void print() = 0;
    virtual void calculateDistance() = 0;
    virtual Point* multiply(Point* other) = 0;
    double getDistance() { return mDistance; }
};

class Point2D : public Point {
public:
    Point2D(double x1, double x2) { mCoordinates.push_back(x1); mCoordinates.push_back(x2); }
    Point2D() { mCoordinates.push_back(0); mCoordinates.push_back(0); mDistance = 0; }
    void print() {
        printf("%.3lf", mCoordinates[0]);
        if (mCoordinates[1] < 0) {
            printf("%.3lfi", mCoordinates[1]);
        } else {
            printf("+%.3lfi", mCoordinates[1]);
        }
        printf(" -> %.3lf\n", mDistance);
    }
    void calculateDistance() { mDistance = std::sqrt(std::pow(mCoordinates[0], 2) + std::pow(mCoordinates[1], 2)); }
    Point* multiply(Point* other) {
        Point2D* point2D = new Point2D();
        for (int i = 0; i < this->mCoordinates.size(); i++) {
            for (int j = 0; j < other->mCoordinates.size(); j++) {
                if (i == 0 && j < this->mCoordinates.size()) {
                    point2D->mCoordinates[j] += this->mCoordinates[i] * other->mCoordinates[j];
                } else if (j == 0) {
                    point2D->mCoordinates[i] += this->mCoordinates[i] * other->mCoordinates[j];
                } else if (i == j) {
                    point2D->mCoordinates[0] -= this->mCoordinates[i] * other->mCoordinates[j];
                }
            }
        }
        return point2D;
    }
};

class Point3D : public Point {
public:
    Point3D(double x1, double x2, double x3) { mCoordinates.push_back(x1); mCoordinates.push_back(x2); mCoordinates.push_back(x3); }
    Point3D() { mCoordinates.push_back(0); mCoordinates.push_back(0); mCoordinates.push_back(0); mDistance = 0; }
    void print() {
        printf("%.3lf", mCoordinates[0]);
        if (mCoordinates[1] < 0) {
            printf("%.3lfi", mCoordinates[1]);
        } else {
            printf("+%.3lfi", mCoordinates[1]);
        }
        if (mCoordinates[2] < 0) {
            printf("%.3lfj", mCoordinates[2]);
        } else {
            printf("+%.3lfj", mCoordinates[2]);
        }
        printf(" -> %.3lf\n", mDistance);
    }
    void calculateDistance() { mDistance = std::cbrt(std::pow(mCoordinates[0], 3) + std::pow(mCoordinates[1], 3) + std::pow(mCoordinates[2], 3)); }
    Point* multiply(Point* other) {
        Point3D* point3D = new Point3D();
        for (int i = 0; i < this->mCoordinates.size(); i++) {
            for (int j = 0; j < other->mCoordinates.size(); j++) {
                if (i == 0 && j < this->mCoordinates.size()) {
                    point3D->mCoordinates[j] += this->mCoordinates[i] * other->mCoordinates[j];
                } else if (j == 0) {
                    point3D->mCoordinates[i] += this->mCoordinates[i] * other->mCoordinates[j];
                } else if (i == j) {
                    point3D->mCoordinates[0] -= this->mCoordinates[i] * other->mCoordinates[j];
                }
            }
        }
        return point3D;
    }
};

class Point4D : public Point {
public:
    Point4D(double x1, double x2, double x3, double x4) { mCoordinates.push_back(x1); mCoordinates.push_back(x2); mCoordinates.push_back(x3); mCoordinates.push_back(x4); }
    Point4D() { mCoordinates.push_back(0); mCoordinates.push_back(0); mCoordinates.push_back(0); mCoordinates.push_back(0); mDistance = 0; }
    void print() {
        printf("%.3lf", mCoordinates[0]);
        if (mCoordinates[1] < 0) {
            printf("%.3lfi", mCoordinates[1]);
        } else {
            printf("+%.3lfi", mCoordinates[1]);
        }
        if (mCoordinates[2] < 0) {
            printf("%.3lfj", mCoordinates[2]);
        } else {
            printf("+%.3lfj", mCoordinates[2]);
        }
        if (mCoordinates[3] < 0) {
            printf("%.3lfk", mCoordinates[3]);
        } else {
            printf("+%.3lfk", mCoordinates[3]);
        }
        printf(" -> %.3lf\n", mDistance);
    }
    void calculateDistance() { mDistance = std::pow(std::pow(mCoordinates[0], 4) + std::pow(mCoordinates[1], 4) + std::pow(mCoordinates[2], 4) + std::pow(mCoordinates[3], 4), 1.0 / 4); }
    Point* multiply(Point* other) {
        Point4D* point4D = new Point4D();
        for (int i = 0; i < this->mCoordinates.size(); i++) {
            for (int j = 0; j < other->mCoordinates.size(); j++) {
                if (i == 0 && j < this->mCoordinates.size()) {
                    point4D->mCoordinates[j] += this->mCoordinates[i] * other->mCoordinates[j];
                } else if (j == 0) {
                    point4D->mCoordinates[i] += this->mCoordinates[i] * other->mCoordinates[j];
                } else if (i == j) {
                    point4D->mCoordinates[0] -= this->mCoordinates[i] * other->mCoordinates[j];
                }
            }
        }
        return point4D;
    }
};

int main() {
    double a, b, c, d;
    char ch;
    std::vector<Point *> points;
    std::vector<Point *> multiplications;
    while(scanf("%lf;%lf", &a, &b) == 2) {
        scanf("%c", &ch);
        if (ch == ';') {
            scanf("%lf", &c);
        } else {
            points.push_back(new Point2D(a, b));
            continue;
        }
        scanf("%c", &ch);
        if (ch == ';') {
            scanf("%lf", &d);
        } else {
            points.push_back(new Point3D(a, b, c));
            continue;
        }
        points.push_back(new Point4D(a, b, c, d));
    }
    for (int i = 0; i < points.size(); i++) {
        for (int j = i + 1; j < points.size(); j++) {
            multiplications.push_back(points[i]->multiply(points[j]));
            multiplications.push_back(points[j]->multiply(points[i]));
            multiplications[multiplications.size() - 1]->calculateDistance();
            multiplications[multiplications.size() - 2]->calculateDistance();
        }
    }
    std::sort(multiplications.begin(), multiplications.end(), [](Point* p1, Point* p2){
        return p1->getDistance() > p2->getDistance();
    });
    multiplications[0]->print();
    return 0;
}
