//
//  Singleton.hpp
//  appguard-ios
//
//  Created by NHNEnt on 2016. 5. 2..
//  Copyright © 2016년 nhnent. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

#include <dispatch/dispatch.h>

template <class T>
class __attribute__((visibility("hidden"))) SingletonHolder {
public:
    SingletonHolder(){}
    ~SingletonHolder(){}
    static T* instance()
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
           if(m_pInstance == NULL)
           {
               m_pInstance = new T;
           }
        });

        return m_pInstance;
    }
private:
    static T *m_pInstance;
};

template<typename T> T *SingletonHolder<T>::m_pInstance;

#define STInstance(x) SingletonHolder<x>::instance()

#endif /* Singleton_h */
