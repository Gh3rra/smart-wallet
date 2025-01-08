import { createClient } from "@supabase/supabase-js";

const supabaseUrl = "https://vnedtoqwbeifzbwscpxn.supabase.co";
const supabaseKey =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuZWR0b3F3YmVpZnpid3NjcHhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzMTQwNTQsImV4cCI6MjA0ODg5MDA1NH0.p8I7k5mphuQgDQ-D0aF0U6fejPdTtbcNDOThlI_to3Q";

const supabase = createClient(supabaseUrl, supabaseKey);

export default supabase;
