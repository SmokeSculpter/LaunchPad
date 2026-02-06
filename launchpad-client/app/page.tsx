'use client'
import Image from "next/image";
import { SignOutButton, useAuth } from "@clerk/nextjs";
import { useEffect } from "react";

export default function Home() {

  return (
    <SignOutButton/>
  );
}
