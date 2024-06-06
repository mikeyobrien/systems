let
  m1max = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExDBDz14sCMA4tmwCnSocR0VNbJjZGVifJGe/VqeBR5 hmobrienv@gmail.com";
  systems = [m1max];
in {
  "some-secret.age".publicKeys = systems;
}
