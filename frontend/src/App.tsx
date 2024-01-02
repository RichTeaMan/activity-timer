import * as React from 'react'

import { Button, ChakraProvider, Container, Heading } from '@chakra-ui/react'

function App() {
  return (
    <ChakraProvider>
      <Heading>Activity Timer</Heading>
      <Container maxW='2xl' centerContent>
        <Button colorScheme='blue'>Hello World</Button>
      </Container>
    </ChakraProvider>
  )
}

export default App;
