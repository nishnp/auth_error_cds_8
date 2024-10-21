namespace my.cap.app;

using { cuid, managed } from '@sap/cds/common';

entity Process : cuid, managed {
  readerTeam : Association to one readerTeam;
  isProtected : Boolean;
}
entity readerTeam : cuid, managed {
    team : String;
}
@(restrict: [
  {
    grant: [
      'READ'
    ],
    to: ['PROCESS_ALL'],
    where: 'isProtected = false'
  },
  {
    grant: [
      'READ'
    ],
    to: ['PROCESS'],
    where: 'isProtected = false and readerTeam.team = $user.Teams'
  }
])
aspect restrictProcesses;

@path: '/sap/ace/ProcessService'
@(requires: [
  'PROCESS_ALL',
  'PROCESS',
])
service ProcessService {
 entity Processes as projection on Process;
 extend Processes with restrictProcesses;
 
}