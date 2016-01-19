module SocketIO where

import Prelude

import Control.Monad.Eff

import Data.Function
import Data.Foreign
import Data.Foreign.Class

foreign import data SocketIO :: !
foreign import data Socket :: *

type Host = String
type Channel = String

type MsgCallback a eff = a -> Eff (socket :: SocketIO | eff) Unit

foreign import stringify :: Foreign -> String

foreign import connect :: forall eff. Host -> (Eff (socket :: SocketIO | eff)
  Socket)

foreign import onMsgImpl :: forall eff. Fn3 Socket Channel
  (MsgCallback String eff) (Eff (socket :: SocketIO | eff) Unit)

foreign import emitImpl :: forall eff. Fn2 Socket Channel
  (Eff (socket :: SocketIO | eff) Unit)

foreign import emitMsgImpl :: forall eff. Fn3 Socket Channel String
  (Eff (socket :: SocketIO | eff) Unit)

onMsg :: forall eff a. (IsForeign a)
      => Socket
      -> Channel
      -> MsgCallback (F a) eff
      -> Eff (socket :: SocketIO | eff) Unit
onMsg s c k = runFn3 onMsgImpl s c (k <<< readJSON)

emit:: forall eff. Socket -> Channel -> Eff (socket :: SocketIO | eff) Unit
emit = runFn2 emitImpl

emitMsg:: forall eff a. Socket
       -> Channel
       -> a
       -> Eff (socket :: SocketIO | eff) Unit
emitMsg s c a = let
  content = stringify $ toForeign a
  emitMsg' = runFn3 emitMsgImpl
  in emitMsg' s c content
