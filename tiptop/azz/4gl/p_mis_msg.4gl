# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: p_mis_msg.4gl
# Descriptions...: 錯誤信息
# Date & Author..: 06/09/25 By Flowld
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
MAIN 
  DEFINE g_msg     STRING,
         g_log     STRING,
         l_i       LIKE type_file.num10,   
         l_cmd     STRING,
         l_c       LIKE type_file.chr20,   
         l_d1      LIKE type_file.chr50, 
         l_d       LIKE type_file.chr50                 
  DEFINE ch        base.channel      
  DEFINE wc        base.channel
  DEFINE wd       base.channel 
  DEFER INTERRUPT 
  IF (NOT cl_user()) THEN
       EXIT PROGRAM
   END IF
 
WHENEVER ERROR call cl_err_msg_log
   
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.TQC-860017 by saki
 
 OPEN WINDOW p_zz_m WITH FORM "azz/42f/p_mis_m"
      ATTRIBUTE(STYLE="err01")
 
 CALL cl_ui_init()
   
    LET l_cmd="ls $TEMPDIR/p_mis_log20*.log >$TEMPDIR/wd.out"
    RUN l_cmd
    LET wd= base.channel.create()
    CALL wd.openFile("/u7/out3/wd.out","r")
    LET l_d1 = wd.readLine()    
    LET l_d =l_d1[10,40] CLIPPED
    CALL wd.close()
    
    LET l_cmd="wc -l $TEMPDIR/",l_d," >$TEMPDIR/wc.out"
    RUN l_cmd 
    LET wc = base.channel.create()
    CALL wc.openFile("/u7/out3/wc.out","r")
    LET l_c = wc.readLine()
    LET l_c = l_c[1,7]
    CALL wc.close()
  
    LET ch = base.channel.create()
    CALL ch.openFile(l_d1 ,"r")
    CALL ch.setDelimiter("")
    LET g_msg=NULL
    LET l_i=1
   WHILE TRUE
     LET g_msg =g_msg,ch.readLine(),"\n"
    IF  g_msg="\n" THEN
     LET g_msg = " No Err List!   "
      EXIT WHILE
    END IF
     IF l_i =l_c THEN
       EXIT WHILE
     END IF
    LET l_i=l_i+1 
   END WHILE
  DISPLAY l_i TO FORMONLY.cnt
  LET l_cmd="rm $TEMPDIR/wc.out"
  RUN l_cmd
  DISPLAY  g_msg CLIPPED TO FORMONLY.msg 
  CALL ch.close()
   
    LET g_log="$TEMPDIR/",l_d CLIPPED
    DISPLAY g_log TO FORMONLY.log
  LET l_cmd = "rm $TEMPDIR/wd.out"
  RUN l_cmd
  
   MENU ""
      ON ACTION quit
         EXIT MENU
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         EXIT MENU
#TQC-860017 start
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
#TQC-860017 end  
    END MENU
  
#   INPUT g_log FROM FORMONLY.log
     
#     ON ACTION quit
   
#    EXIT INPUT
#   END INPUT
    CLOSE WINDOW p_zz_m
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.TQC-860017 by saki
END MAIN
 
