import * as React from 'react'

import { Button, ChakraProvider } from '@chakra-ui/react'

function App() {
  return (
    <ChakraProvider>
      <Button colorScheme='blue'>Hello World</Button>
    </ChakraProvider>
  )
}

export default App;
