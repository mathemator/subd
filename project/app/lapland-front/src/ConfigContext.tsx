import React, { createContext, useContext, ReactNode } from 'react';

const ConfigContext = createContext<{ serverUrl: string }>({ serverUrl: import.meta.env.VITE_API_URL || '' });

interface ConfigProviderProps {
  children: ReactNode;
}

export const ConfigProvider: React.FC<ConfigProviderProps> = ({ children }) => {
  return (
    <ConfigContext.Provider value={{ serverUrl: import.meta.env.VITE_API_URL || '' }}>
      {children}
    </ConfigContext.Provider>
  );
};

export const useConfig = () => useContext(ConfigContext);
