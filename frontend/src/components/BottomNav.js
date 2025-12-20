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
    { icon: MessageCircle, label: 'Chat', path: '/chat', testId: 'nav-chat' },
    { icon: User, label: 'Perfil', path: '/profile', testId: 'nav-profile' },
  ];

  if (user?.role === 'admin') {
    navItems.push({ icon: Settings, label: 'Admin', path: '/admin', testId: 'nav-admin' });
  }

  return (
    <div className="bottom-nav h-14 flex items-center justify-evenly px-0.5 safe-area-bottom" data-testid="bottom-navigation">
      {navItems.map((item) => {
        const Icon = item.icon;
        const isActive = location.pathname === item.path;
        return (
          <button
            key={item.path}
            data-testid={item.testId}
            onClick={() => navigate(item.path)}
            className={`flex flex-col items-center justify-center py-1 px-0.5 rounded-lg transition-all flex-1 min-w-0 ${
              isActive
                ? 'text-primary'
                : 'text-gray-400 active:text-gray-600'
            }`}
          >
            <Icon size={18} className="flex-shrink-0" strokeWidth={isActive ? 2.5 : 2} />
            <span className={`text-[8px] sm:text-[10px] font-medium text-center leading-tight mt-0.5 truncate w-full ${isActive ? 'text-primary' : ''}`}>
              {item.label}
            </span>
          </button>
        );
      })}
    </div>
  );
}
