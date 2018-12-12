package com.example.demo.util;

import java.util.Random;

public class RandomNumber {

    public static Long getRandomNumberInRange(int min, int max) {

        if (min >= max) {
            throw new IllegalArgumentException("max must be greater than min");
        }

        Random r = new Random();
        return new Long(r.nextInt((max - min) + 1) + min);
    }
}
