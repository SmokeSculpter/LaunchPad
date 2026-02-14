import Nav from "@/components/navigation/Nav";
import DashboardHeader from "@/components/dashboard/DashboardHeader";

import { Grid, Card, Container } from "@mui/material";

export default function Home() {

  return (
    <Nav>
      <Grid className="p-4" container spacing={2}>
        <Grid size={ {lg:6, md:12, sm:12, xs:12 }}>
          <Card className="h-[calc(100dvh-8rem)]">
            <Container className="p-4 h-full">
              <DashboardHeader/>
            </Container>
          </Card>
        </Grid>
        <Grid size={{ lg:6, md:12, sm:12, xs:12 }}>
          <Card className="h-[calc(100dvh-8rem)]">

          </Card>
        </Grid>
      </Grid>
    </Nav>
  );
}
