if upper(substr(produtn.vendcd,1,2))='MB'
  repl wip.dfrmvend with wip.dbind
 else
 vensrch=produtn.vendcd
 sele vendor
 set order to vendcd
 seek vensrch
 if found() 
  repl wip.dfrmvend with produtn.tovend+vendor.vchrno
 endif
 endif
 sele produtn
 thisform.refresh
 