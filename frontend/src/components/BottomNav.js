import React, { useContext } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Home, MessageCircle, Search, User, Settings, Users, MapPin } from 'lucide-react';
import { AuthContext } from '../App';

export default function BottomNav() {
  const navigate = useNavigate();
  const location = useLocation();
  const { user } = useContext(AuthContext);

  const navItems = [
    { icon: Home, label: 'Home', path: '/home', testId: 'nav-home' },
    { icon: MapPin, label: 'Mapa', path: '/nearby', testId: 'nav-nearby' },
    { icon: Users, label: 'Voluntários', path: '/volunteers', testId: 'nav-volunteers' },
    { icon: MessageCircle, label: 'Chat AI', path: '/chat', testId: 'nav-chat' },
    { icon: User, label: 'Perfil', path: '/profile', testId: 'nav-profile' },
  ];

  if (user?.role === 'admin') {
    navItems.push({ icon: Settings, label: 'Admin', path: '/admin', testId: 'nav-admin' });
  }

  return (
    <div className="bottom-nav h-14 sm:h-16 flex items-center justify-around px-1" data-testid="bottom-navigation">
      {navItems.map((item) => {
        const Icon = item.icon;
        const isActive = location.pathname === item.path;
        return (
          <button
            key={item.path}
            data-testid={item.testId}
            onClick={() => navigate(item.path)}
            className={`flex flex-col items-center justify-center gap-0.5 px-1 sm:px-3 py-1.5 sm:py-2 rounded-lg sm:rounded-xl transition-all flex-1 max-w-[70px] sm:max-w-none ${
              isActive
                ? 'text-primary bg-primary/5'
                : 'text-gray-500 hover:text-gray-700 hover:bg-gray-50'
            }`}
          >
            <Icon size={20} className="sm:w-6 sm:h-6 flex-shrink-0" strokeWidth={isActive ? 2.5 : 2} />
            <span className="text-[9px] sm:text-xs font-medium text-center leading-tight truncate w-full">{item.label}</span>
          </button>
        );
      })}
    </div>
  );
}
