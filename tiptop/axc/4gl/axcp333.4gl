# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp333.4gl
# Descriptions...: 成本要素資料更新作業
# Date & Author..: 99/03/24 By Sophia
 # Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
 # Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/19 By yjkhero 類型轉換 
# Modify.........: No.FUN-660191 06/10/17 By rainy update imb2151改update imb216
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-790087 07/09/17 By Sarah 修正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.MOD-7C0106 07/12/17 By Pengu 在INSERT imb_file時應給imb1251 default值
# Modify.........: No.FUN-8A0086 08/12/21 By lutingting完善錯誤訊息修改 
# Modify.........: No.CHI-970024 09/07/10 By mike 增加報錯訊息
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A20114 10/03/29 By Summer imb214應包含製費一~製費五,imb220改寫入0
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管  
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B70138 11/07/17 By Summer insert into imb2151及imb216時有誤
# Modify.........: No:FUN-C80092 12/12/05 By xujing 成本相關作業增加日誌功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE yy,mm      LIKE type_file.num5,     #No.FUN-680098   SMALLINT
       g_wc       string,                  #No.FUN-580092   HCN
       g_flag     LIKE type_file.chr1      #No.FUN-680098   VARCHAR(01)
DEFINE l_flag          LIKE type_file.chr1,    #No.FUN-570153   #No.FUN-680098 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,    #是否有做語言切換 No.FUN-570153 VARCHAR(1)
       ls_date         STRING                  #->No.FUN-570153
DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-680098  SMALLINT
DEFINE g_cka00         LIKE cka_file.cka00     #FUN-C80092 add
DEFINE g_cka09         LIKE cka_file.cka09     #FUN-C80092 add

MAIN
#     DEFINE   l_time   LIKE type_file.chr8         #No.FUN-6A0146
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
#->No.FUN-570153 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc  = ARG_VAL(1)                      
   LET yy    = ARG_VAL(2)                      
   LET mm    = ARG_VAL(3)                      
   LET g_bgjob  = ARG_VAL(4)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570153 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
#NO.FUN-570153 mark--
#   LET g_wc =ARG_VAL(1)
#   LET yy   =ARG_VAL(2)
#   LET mm   =ARG_VAL(3)
#   IF NOT cl_null(g_wc) THEN
#       LET g_success='Y'
#       BEGIN WORK
#       CALL p333()
#       IF g_success = 'Y' THEN
#           COMMIT WORK
#       ELSE
#           ROLLBACK WORK
#       END IF
#       DISPLAY "p333()= ",g_success
#   ELSE
#       LET p_row = 1 LET p_col = 1
#       
#       OPEN WINDOW p333_w AT p_row,p_col WITH FORM "axc/42f/axcp333" 
#           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#        
#       CALL cl_ui_init()
#       
#       
#       CALL cl_opmsg('q')
#       LET yy=g_ccz.ccz01
#       LET mm=g_ccz.ccz02
#       DISPLAY BY NAME yy,mm
#       WHILE TRUE 
#          LET g_flag='Y'
#          CALL p333_ask()
#          IF g_flag = 'N' THEN
#             CONTINUE WHILE
#          END IF
#          IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#          IF cl_sure(21,21) THEN 
#             CALL cl_wait()
#             BEGIN WORK
#             LET g_success = 'Y'
#             CALL p333()
#             IF g_success = 'Y' THEN
#                 COMMIT WORK
#                 CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#             ELSE
#                 ROLLBACK WORK
#                 CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#             END IF
#             IF g_flag THEN
#                CONTINUE WHILE
#             ELSE
#                EXIT WHILE
#             END IF
#          END IF
#       END WHILE
#       #CALL cl_end(0,0) 
#       CLOSE WINDOW p333_w
#   END IF
#NO.FUN-570153 mark--
 
#NO.FUN-570153 start--
   LET g_success = 'Y'
   WHILE TRUE
      LET g_flag = 'Y' 
      IF g_bgjob = "N"  THEN #AND cl_null(g_wc) THEN
         CLEAR FORM
         CALL p333_ask()
         IF g_flag = 'N' THEN
            CONTINUE WHILE
         END IF
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            #FUN-C80092--add--str--
            LET g_cka09 = " yy='",yy,"'; mm='",mm,"'; g_bgjob='",g_bgjob,"'"
            CALL s_log_ins(g_prog,yy,mm,g_wc,g_cka09) RETURNING g_cka00
            #FUN-C80092--add--end--
            BEGIN WORK
            LET g_success = 'Y'
            CALL p333()
            CALL s_showmsg()        #No.FUN-710027   
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN 
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p333_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p333_w
      ELSE
         #FUN-C80092--add--str--
         LET g_cka09 = " yy='",yy,"'; mm='",mm,"'; g_bgjob='",g_bgjob,"'"
         CALL s_log_ins(g_prog,yy,mm,g_wc,g_cka09) RETURNING g_cka00
         #FUN-C80092--add--end--
         BEGIN WORK
         LET g_success = 'Y'
         CALL p333()
         CALL s_showmsg()        #No.FUN-710027   
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570153 --end--
#  CALL cl_used('axcp333',g_time,2) RETURNING g_time   #No.FUN-6A0146
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p333_ask()
   DEFINE   c     LIKE type_file.chr20       #No.FUN-680098  VARCHAR(10)
   DEFINE lc_cmd  LIKE type_file.chr1000     #No.FUN-570153  #No.FUN-680098 VARCHAR(500)
 
#->No.FUN-570153 --start--
   LET p_row = 1 LET p_col = 1
   
   OPEN WINDOW p333_w AT p_row,p_col WITH FORM "axc/42f/axcp333" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   
   CALL cl_opmsg('q')
 
   LET yy=g_ccz.ccz01
   LET mm=g_ccz.ccz02
   DISPLAY BY NAME yy,mm
#->No.FUN-570153 --end--
 
   ERROR ''
   CONSTRUCT BY NAME g_wc ON ccc01 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
    #MOD-530850   
      ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(ccc01)  
#FUN-AA0059---------mod------------str-----------------                                                           
#            CALL cl_init_qry_var()                                              
#            LET g_qryparam.form = "q_ima"                                       
#            LET g_qryparam.state = "c"                                          
#            CALL cl_create_qry() RETURNING g_qryparam.multiret 
            CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------              
            DISPLAY g_qryparam.multiret TO ccc01                                
            NEXT FIELD ccc01                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
    #--
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale                    #genero
#NO.FUN-570153 start--
#         LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE
#NO.FUN-571053 end--
         EXIT CONSTRUCT
 
       ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cccuser', 'cccgrup') #FUN-980030
#NO.FUN-570153 statr---
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      LET g_flag = 'N'
#      RETURN
#   END IF
#   IF INT_FLAG THEN
#      RETURN
#   END IF
#->No.FUN-570153 ---start---   
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
      RETURN
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p333_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#NO.FUN-570153 end---
 
   LET g_wc=g_wc CLIPPED," AND ccc01 NOT MATCHES 'MISC*'"
   LET g_bgjob = 'N'    # FUN-570153
 
   #INPUT BY NAME yy,mm WITHOUT DEFAULTS 
   INPUT BY NAME yy,mm,g_bgjob WITHOUT DEFAULTS    #NO.FUN-570153 
 
      AFTER FIELD yy
         IF cl_null(yy) THEN 
            NEXT FIELD yy
         END IF
 
      AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = yy
            IF g_azm.azm02 = 1 THEN
               IF mm > 12 OR mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF mm > 13 OR mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(mm) THEN
            NEXT FIELD mm
         END IF
 
      AFTER INPUT 
#->No.FUN-570153 ---start---   
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p333_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
#         IF INT_FLAG THEN
#            RETURN 
#         END IF
#NO.FUN-570153 
         IF yy*12+mm < g_ccz.ccz01*12+g_ccz.ccz02 THEN
            CALL cl_err('','axc-095',0) #CHI-970024
            NEXT FIELD yy
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
   
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
 
   END INPUT
#->No.FUN-570153 ---start---   
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p333_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B40028
      EXIT PROGRAM
   END IF
   #IF INT_FLAG THEN
   #   RETURN
   #END IF
 
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axcp333"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axcp333','9031',1)   
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED ,"'",
                      " '",yy CLIPPED ,"'",
                      " '",mm CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axcp333',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p333_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
#->No.FUN-570153 ---end---   
 
END FUNCTION
 
FUNCTION p333()
  DEFINE l_sql     LIKE type_file.chr1000,  #No.FUN-680098 VARCHAR(300)
         l_ccc     RECORD LIKE ccc_file.*,
         l_ccc23c   LIKE ccc_file.ccc23c     #MOD-A20114 add
 
   LET l_sql = "SELECT * FROM ccc_file,ima_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND ccc01 = ima01 ",
               "   AND ccc02 = ",yy,"",
               "   AND ccc03 = ",mm,""
   PREPARE p333_pre FROM l_sql
   DECLARE p333_c1 CURSOR FOR p333_pre
   CALL s_showmsg_init()   #No.FUN-710027
   FOREACH p333_c1 INTO l_ccc.*
      IF STATUS THEN 
#         CALL cl_err('foreach:',STATUS,0)           #No.FUN-710027 
         CALL s_errmsg('','','foreach:',STATUS,0)    #No.FUN-710027
         LET g_success = 'N'                         #No.FUN-8A0086 
         EXIT FOREACH 
      END IF
 
#No.FUN-710027--begin 
      IF g_success='N' THEN  
         LET g_totsuccess='N'  
         LET g_success="Y"   
      END IF 
#No.FUN-710027--end

    #str MOD-A20114 add
    #imb214(現時本階固定製造費用成本)應為製費1+2+3+4+5
     LET l_ccc23c = l_ccc.ccc23c + l_ccc.ccc23e + l_ccc.ccc23f +
                    l_ccc.ccc23g + l_ccc.ccc23h
     IF cl_null(l_ccc23c) THEN LET l_ccc23c = 0 END IF
    #end MOD-A20114 add

 
      INSERT INTO imb_file(imb01    ,imb02   ,imb111  ,imb112  ,imb1131 ,imb1132 ,imb114  ,imb115  ,
                           imb1151  ,imb116  ,imb1171 ,imb1172 ,imb119  ,imb118  ,imb120  ,imb121  ,
                           imb122   ,imb1231 ,imb1232 ,imb124  ,imb125  ,imb1251 ,imb126  ,imb1271 ,
                           imb1272  ,imb129  ,imb130  ,imb211  ,imb212  ,imb2131 ,imb2132 ,imb214  ,
                          #-----------No.MOD-7C0106 modify
                           imb215   ,imb2151 ,imb216  ,imb2171 ,imb2172 ,imb219  ,imb218  ,imb220  ,  #FUN-660191 remark
                          #imb215   ,imb216  ,imb2171 ,imb2172 ,imb219  ,imb218  ,imb220  ,           #FUN-660191
                          #-----------No.MOD-7C0106 end
                           imb221   ,imb222  ,imb2231 ,imb2232 ,imb224  ,imb225  ,imb2251 ,imb226  ,
                           imb2271  ,imb2272 ,imb229  ,imb230  ,imb311  ,imb312  ,imb3131 ,imb3132 ,
                           imb314   ,imb315  ,imb3151 ,imb316  ,imb3171 ,imb3172 ,imb319  ,imb318  ,
                           imb320   ,imb321  ,imb322  ,imb3231 ,imb3232 ,imb324  ,imb325  ,imb3251 ,
                           imb326   ,imb3271 ,imb3272 ,imb329  ,imb330  ,imbacti ,imbuser ,imbgrup ,
                            imbmodu  ,imbdate,imboriu,imborig) #No.MOD-470041 
                  VALUES(l_ccc.ccc01,'1',0,0,0,0,0,0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,0,0,0,0,l_ccc.ccc23a,0,l_ccc.ccc23b,0,
                 ##---------------No.MOD-7C0106 modify
                 #l_ccc.ccc23c,0,l_ccc.ccc23d,0,0,0,0,l_ccc.ccc23,l_ccc.ccc23e,   #FUN-660191 remark #MOD-A20114 mark
                 #l_ccc23c,0,l_ccc.ccc23d,0,0,0,0,l_ccc.ccc23,0,                  #MOD-A20114 #MOD-B70138 mark
                  l_ccc23c,0,0,l_ccc.ccc23d,0,0,0,l_ccc.ccc23,0,                  #MOD-B70138
                 ##l_ccc.ccc23c,0,l_ccc.ccc23d,0,0,0,l_ccc.ccc23,l_ccc.ccc23e,     #FUN-660191
                 ##---------------No.MOD-7C0106 end
                  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                  0,0,0,0,0,0,0,0,'Y',g_user,g_grup,' ',g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
     #IF SQLCA.SQLCODE=-239 OR SQLCA.SQLCODE=-268 THEN   #TQC-790087 mark
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN            #TQC-790087
         UPDATE imb_file SET imb211 = l_ccc.ccc23a,
                             imb2131= l_ccc.ccc23b,
                            #imb214 = l_ccc.ccc23c,   #MOD-A20114 mark
                             imb214 = l_ccc23c,       #MOD-A20114
                            #imb2151= l_ccc.ccc23d,   #FUN-660191 remark
                             imb216= l_ccc.ccc23d,    #FUN-660191
                            #imb220 = l_ccc.ccc23e,   #MOD-A20114 mark
                             imb220 = 0,              #MOD-A20114
                             imb218 = l_ccc.ccc23
          WHERE imb01 = l_ccc.ccc01
          IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3]=0 THEN
#            CALL cl_err('upd imb',SQLCA.SQLCODE,0)   #No.FUN-660127
#             CALL cl_err3("upd","imb_file",l_ccc.ccc01,"",SQLCA.SQLCODE,"","upd imb",0)   #No.FUN-660127  #No.FUN-710027 
             CALL s_errmsg('imb01',l_ccc.ccc01,'upd imb',SQLCA.SQLCODE,1)                                  #No.FUN-710027 
             LET g_success = 'N'
          END IF
       ELSE
          IF SQLCA.SQLCODE THEN
#             CALL cl_err('ins imb:',SQLCA.SQLCODE,1)  #No.FUN-660127
#              CALL cl_err3("upd","imb_file",l_ccc.ccc01,"",SQLCA.SQLCODE,"","ins imb:",1)   #No.FUN-660127  #No.FUN-710027 
               CALL s_errmsg('imb01',l_ccc.ccc01,'upd imb',SQLCA.SQLCODE,1)                                  #No.FUN-710027 
             LET g_success = 'N'
          END IF
       END IF
    END FOREACH
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end                         
 
END FUNCTION
