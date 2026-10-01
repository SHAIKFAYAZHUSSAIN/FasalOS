import React from 'react';

interface FasalLogoProps {
  className?: string;
  size?: 'sm' | 'md' | 'lg';
  showTagline?: boolean;
}

export const FasalLogo: React.FC<FasalLogoProps> = ({
  className = '',
  size = 'md',
  showTagline = false,
}) => {
  const iconSizes = {
    sm: 'w-7 h-7',
    md: 'w-9 h-9',
    lg: 'w-12 h-12',
  };

  const textSizes = {
    sm: 'text-lg',
    md: 'text-2xl',
    lg: 'text-3xl',
  };

  return (
    <div className={`flex items-center gap-2.5 select-none ${className}`}>
      {/* Brand Icon: Deep Green Base + Natural Sprout + Harvest Amber Sun Node */}
      <div
        className={`${iconSizes[size]} rounded-xl bg-gradient-to-br from-[#1B4332] via-[#2D6A4F] to-[#143626] flex items-center justify-center shadow-md shadow-[#1B4332]/20 flex-shrink-0 relative overflow-hidden p-1.5`}
      >
        <svg
          viewBox="0 0 32 32"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          className="w-full h-full text-white"
        >
          {/* Leaf Contour */}
          <path
            d="M8 24C8 14.5 16.5 8 24 10C24 17.5 17.5 24 8 24Z"
            fill="#52B788"
            fillOpacity="0.9"
          />
          {/* Vein / Circuit */}
          <path
            d="M8 24L19 13M19 13L14 11M19 13L21 17"
            stroke="#FAF9F5"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
          {/* Intelligence / Solar Amber Core */}
          <circle cx="23" cy="9" r="3" fill="#F59E0B" />
        </svg>
      </div>

      <div className="flex flex-col">
        <div className="flex items-center">
          <span className={`font-bold tracking-tight text-[#18221E] font-heading ${textSizes[size]}`}>
            Fasal<span className="text-[#2D6A4F]">OS</span>
          </span>
          <span className="ml-1.5 text-[10px] font-semibold tracking-wider uppercase px-1.5 py-0.5 rounded bg-[#D8F3DC] text-[#1B4332]">
            Kurnool Hub
          </span>
        </div>
        {showTagline && (
          <span className="text-xs text-[#5C6761] font-medium hidden sm:inline">
            From harvest to the right market
          </span>
        )}
      </div>
    </div>
  );
};
