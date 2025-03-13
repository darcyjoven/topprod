# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aemp100.4gl
# Descriptions...: 設備保養作業-基于時間周期
# Date & Author..: 04/07/30 By Elva  
# Modify.........: No.FUN-550024 05/05/20 By Trisy 單據編號加大
# Modify.........: No.MOD-530629 05/06/08 By Carrier 更改單據查詢
# Modify.........: NO.FUN-560014 05/06/09 By jackie 單據編號修改
# Modify.........: No.MOD-560238 05/07/27 By vivien 自動編號修改
# Modify.........: No.TQC-630104 06/03/14 By Smapmin DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680072 06/08/24 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-770003 07/07/01 By arman help按鈕是灰色的
# Modify.........: No.TQC-930032 09/03/06 By mike DISPLAY BY NAME g_fil01 應改為  DISPLAY g_fil01 TO FORMONLY.f 
#                                                 DISPLAY BY NAME g_fil04 應改為  DISPLAY g_fil01 TO FORMONLY.k
# Modify.........: No.FUN-980002 09/08/20 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B80026 11/08/03 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    l_cmd           LIKE type_file.chr1000,         #string command variable        #No.FUN-680072char(300)
          g_t1            LIKE type_file.chr5,            #No.FUN-550024                  #No.FUN-680072CHAR(05)
          g_fil           RECORD LIKE fil_file.*,         #No.FUN-550024   
          g_fia DYNAMIC ARRAY OF RECORD            
               fia01    LIKE fia_file.fia01,    
               fia02    LIKE fia_file.fia02,    
               fjc03    LIKE fjc_file.fjc03,    
               fio05    LIKE fio_file.fio05,    
               desc     LIKE type_file.chr8,                #No.FUN-680072CHAR(8)
               fio06    LIKE fio_file.fio06,    
               fiu02    LIKE fiu_file.fiu02,    
               fio07    LIKE fio_file.fio07,    
               fja02    LIKE fja_file.fja02,    
               fio08    LIKE fio_file.fio08,    
               fio03    LIKE fio_file.fio03,    
               fio04    LIKE fio_file.fio04     
                END RECORD,
        g_fjc03_t   LIKE fjc_file.fjc03,
        g_fil01     LIKE fil_file.fil01,
        g_fil04     LIKE fil_file.fil04,
        g_sql       STRING,                #No.FUN-580092 HCN
        g_rec_b     LIKE type_file.num5,                  #No.FUN-680072 SMALLINT
        s_t         LIKE type_file.num5,                  #No.FUN-680072 SMALLINT
        l_no        LIKE type_file.num5,                  #No.FUN-680072 SMALLINT
        m_status    LIKE type_file.num5,                  #No.FUN-680072 SMALLINT
        l_c         LIKE type_file.num5,                  #No.FUN-680072 SMALLINT
        l_ac        LIKE type_file.num5                   #No.FUN-680072 SMALLINT
DEFINE  g_cnt       LIKE type_file.num10            #No.FUN-680072 INTEGER
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AEM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
 
   OPEN WINDOW p100_w WITH FORM "aem/42f/aemp100" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL p100_cmd()          #condition input
 
   CLOSE WINDOW p100_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
END MAIN
 
 
 
FUNCTION p100_cmd()
    DEFINE l_flag         LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
    DEFINE li_result      LIKE type_file.num5          #No.FUN-560014        #No.FUN-680072 SMALLINT
 
    CALL cl_opmsg('z')
    WHILE TRUE
        IF s_shut(0) THEN RETURN END IF
        CLEAR FORM 
        CALL g_fia.clear()
 
        CONSTRUCT l_cmd ON fia01,fio05,fio08,fio06,fio07
             FROM e,a,d,b,c      #QBE 輸入條件
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(e)   #設備編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_fia" 
                    LET g_qryparam.state = "c"                    
                    CALL cl_create_qry() RETURNING g_qryparam.multiret     
                    DISPLAY g_qryparam.multiret TO e               
                    NEXT FIELD e
               WHEN INFIELD(b)   #保養周期
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_fiu" 
                    LET g_qryparam.state = "c"                    
                    CALL cl_create_qry() RETURNING g_qryparam.multiret     
                    DISPLAY g_qryparam.multiret TO b               
                    NEXT FIELD b
               WHEN INFIELD(c)  #保修規模
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_fja" 
                    LET g_qryparam.state = "c"                    
                    CALL cl_create_qry() RETURNING g_qryparam.multiret     
                    DISPLAY g_qryparam.multiret TO c               
                    NEXT FIELD c 
            END CASE
 
          ON ACTION locale
             CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()   #FUN-550037(smin)
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
          ON ACTION help          #TQC-770003 
             CALL cl_show_help()  #TQC-770003
          
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
          ON ACTION exit                            #加離開功能
             LET INT_FLAG = 1
             EXIT CONSTRUCT
        
        END CONSTRUCT
        LET l_cmd = l_cmd CLIPPED,cl_get_extra_cond('fiauser', 'fiagrup') #FUN-980030
 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
        END IF
        INPUT g_fil01,g_fil04 WITHOUT DEFAULTS FROM f,k
           AFTER FIELD f                                                       
             IF NOT cl_null(g_fil01) THEN           
#No.FUN-560014 --start--
#               LET g_errno = ' '                                     
#               LET g_t1 = g_fil01[1,3] 
               LET g_t1=g_fil01[1,g_doc_len]     #No.FUN-550024      
                CALL s_check_no("aem",g_t1,"","1","","","")    #No.MOD-560238
                    RETURNING li_result,g_fil01  #No.FUN-560014
               LET g_t1=g_fil01[1,g_doc_len]  #No.FUN-560014
               DISPLAY g_t1 TO FORMONLY.f
               IF (NOT li_result) THEN
                    NEXT FIELD f
                END IF
#              CALL s_mfgslip(g_t1,'aem','1')                                   
#              IF NOT cl_null(g_errno) THEN                   #抱歉, 有問題     
#                  CALL cl_err(g_t1,g_errno,0) 
#                  NEXT FIELD f
#              END IF
             END IF                                                          
#No.FUN-560014 --start--
 
           AFTER FIELD k
            IF NOT cl_null(g_fil04) THEN
               SELECT fje01 FROM fje_file WHERE  fje01= g_fil04       
               IF STATUS THEN                                                   
#                 CALL cl_err(g_fil04,STATUS ,0)                         #No.FUN-660092
                  CALL cl_err3("sel","fje_file",g_fil04,"",STATUS,"","",1)  #No.FUN-660092
                  NEXT FIELD k                                              
               END IF 
            END IF
                                                                                
            ON ACTION CONTROLR                                                  
               CALL cl_show_req_fields()                                        
                                                                                
            ON ACTION CONTROLG                                                  
               CALL cl_cmdask()                                                 
 
            ON ACTION CONTROLP                                     
               CASE                                                     
                  WHEN INFIELD(f)                                   
#                    LET g_t1=g_fil01[1,3]                          
                     LET g_t1=g_fil01[1,g_doc_len]  #No.FUN-560014     #No.FUN-550024 
 #No.MOD-560238 --start
                     CALL q_smy(FALSE,FALSE,g_t1,'AEM','1') RETURNING g_t1  #TQC-670008
                      #No.MOD-530629  --begin                                                                                        
#                     CALL q_fjh(FALSE,FALSE,g_t1,'aem','01') RETURNING g_t1                                                         
                      #No.MOD-530629  --end   
 #No.MOD-560238 --end  
#                    LET g_fil01[1,3]=g_t1                
                     LET g_fil01 = g_t1                 #No.FUN-550024 
                    #DISPLAY BY NAME g_fil01 #TQC-930032
                     DISPLAY g_fil01 TO FORMONLY.f ##TQC-930032       
                     NEXT FIELD f
                  WHEN INFIELD(k) 
                     CALL cl_init_qry_var()                           
                     LET g_qryparam.default1 = g_fil04            
                     LET g_qryparam.form ="q_fje"                     
                     CALL cl_create_qry() RETURNING g_fil04       
                    #DISPLAY BY NAME g_fil04 #TQC-930032
                     DISPLAY g_fil04 TO FORMONLY.k #TQC-930032                     
                     NEXT FIELD k  
               END CASE
 
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
 
        END INPUT
 
        IF INT_FLAG THEN 
            LET INT_FLAG = 0
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
        END IF
 
        CALL p100_fill() returning s_t    #抓取符合資料填入陣列
        IF  s_t <=0 THEN                  #無符合之資料
            CALL cl_err( ' ','mfg3122',0)
            CONTINUE  WHILE 
        END IF
        
        CALL p100_array()
        IF cl_sure(0,0) THEN
           BEGIN WORK
           LET g_success='Y'
           CALL p100_gen()   
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              EXIT WHILE
           END IF
        ELSE
           EXIT  WHILE 
        END IF
    END WHILE
    ERROR ""
END FUNCTION
 
FUNCTION p100_fill()
#DEFINE    l_time    LIKE type_file.chr8           #No.FUN-6A0068
DEFINE     l_wc      LIKE type_file.chr1000,       # RDSQL STATEMENT                      #No.FUN-680072CHAR(200)
           l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                      #No.FUN-680072CHAR(610)
           l_cnt     LIKE type_file.num5                                                  #No.FUN-680072 SMALLINT
 
    LET l_sql = "  SELECT fia01,fia02,fjc03,fio05,'',fio06,fiu02,",
                "   fio07,fja02,fio08,fio03,fio04 ",
                "  FROM fia_file,fjc_file,fio_file,",
                "  OUTER fiu_file,OUTER fja_file ",
                "  WHERE fiu_file.fiu01 = fio_file.fio06 ",
                "    AND fja_file.fja01 = fio_file.fio07 ",
                "    AND fia01 = fjc01 AND fjc03=fio01",
                "    AND ",l_cmd CLIPPED,
                "    ORDER BY fia01,fio05,fjc03 "
 
    PREPARE p100_prepare FROM l_sql #prepare it
    DECLARE p100_cur CURSOR FOR p100_prepare
    CALL g_fia.clear()                                                      
    LET l_ac = 1
    FOREACH p100_cur INTO g_fia[l_ac].*
        IF SQLCA.sqlcode != 0 THEN 
            CALL cl_err('cannot foreach ',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        CASE g_fia[l_ac].fio05
           WHEN  '1' CALL cl_getmsg('aem-023',g_lang) RETURNING g_fia[l_ac].desc
           WHEN  '2' CALL cl_getmsg('aem-033',g_lang) RETURNING g_fia[l_ac].desc
           OTHERWISE  LET g_fia[l_ac].desc = ''    
        END CASE      
        LET l_ac = l_ac + 1
        #-----TQC-630104---------
        #IF l_ac > g_max_rec THEN EXIT FOREACH END IF   
        IF l_ac > g_max_rec THEN 
           CALL cl_err('',9035,0)
           EXIT FOREACH 
        END IF   
        #-----END TQC-630104-----
    END FOREACH
    LET g_rec_b=l_ac-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    RETURN g_rec_b
END FUNCTION
    
FUNCTION p100_array()
    DEFINE
          l_ac    LIKE type_file.num5,          #No.FUN-680072 SMALLINT
          j,i     LIKE type_file.num5,          #No.FUN-680072 SMALLINT
          l_allow_delete  LIKE type_file.num5                  #可刪除否        #No.FUN-680072 SMALLINT
 
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_fia WITHOUT DEFAULTS FROM s_fia.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=l_allow_delete,APPEND ROW=FALSE)
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET g_fjc03_t = g_fia[l_ac].fjc03
 
        AFTER FIELD fjc03
            IF NOT cl_null(g_fia[l_ac].fjc03) AND 
                       g_fia[l_ac].fjc03 != g_fjc03_t THEN
               LET m_status = 0 
               FOR j=1 TO g_rec_b
                   IF j<>l_ac THEN
                      IF g_fia[j].fia01 = g_fia[l_ac].fia01 AND
                         g_fia[j].fjc03 = g_fia[l_ac].fjc03 THEN
                         LET m_status = m_status + 1
                      END IF
                   END IF
               END FOR
               IF m_status > 0 THEN
                  LET g_fia[l_ac].fjc03 = g_fjc03_t
                  CALL cl_err(g_fia[l_ac].fjc03,-239,0)
                  NEXT FIELD fjc03
               ELSE
                  LET i=0
                  SELECT COUNT(*) INTO i FROM fjc_file
                   WHERE fjc01=g_fia[l_ac].fia01
                     AND fjc03=g_fia[l_ac].fjc03
                  IF i < 1 THEN
#                     CALL cl_err(g_fia[l_ac].fjc03,'aem-034',0)
                      CALL cl_err(g_fia[l_ac].fjc03,'aem-044',0)  #No.MOD-530629
                     NEXT FIELD fjc03
                  END IF
                  SELECT UNIQUE fjc03,fio05,'',fio06,fiu02,
                         fio07,fja02,fio08,fio03,fio04
                    INTO g_fia[l_ac].fjc03,g_fia[l_ac].fio05,
                         g_fia[l_ac].desc, g_fia[l_ac].fio06,
                         g_fia[l_ac].fiu02,g_fia[l_ac].fio07,
                         g_fia[l_ac].fja02,g_fia[l_ac].fio08,
                         g_fia[l_ac].fio03,g_fia[l_ac].fio04 
                    FROM fjc_file,fio_file,OUTER fiu_file,OUTER fja_file
                   WHERE fiu_file.fiu01 = fio_file.fio06
                     AND fja_file.fja01 = fio_file.fio07
                     AND fjc03=fio01
                     AND fio01 = g_fia[l_ac].fjc03
                  IF SQLCA.sqlcode THEN 
#                     CALL cl_err('after field fjc03 ',SQLCA.sqlcode,1)    #No.FUN-660092
                      CALL cl_err3("sel","fjc_file,fio_file",g_fia[l_ac].fjc03,"",SQLCA.sqlcode,"","after field fjc03 ",1)  #No.FUN-660092
                      LET g_fia[l_ac].fjc03=g_fjc03_t
                      NEXT FIELD fjc03
                  END IF
                  CASE g_fia[l_ac].fio05
                     WHEN  '1' CALL cl_getmsg('aem-023',g_lang) RETURNING g_fia[l_ac].desc
                     WHEN  '2' CALL cl_getmsg('aem-033',g_lang) RETURNING g_fia[l_ac].desc
                     OTHERWISE  LET g_fia[l_ac].desc = ''    
                  END CASE      
               END IF
            END IF
 
       BEFORE DELETE
           IF NOT cl_delb(0,0) THEN                                        
              CANCEL DELETE                                                
           END IF
           LET g_rec_b=g_rec_b-1                                           
           DISPLAY g_rec_b TO FORMONLY.cn2                                 
           MESSAGE "Delete Ok" 
 
       ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
                                                                                
       ON ACTION CONTROLG                                                      
           CALL cl_cmdask()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fjc03)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_fio" 
                  LET g_qryparam.default1 = g_fia[l_ac].fjc03                 
                  CALL cl_create_qry() RETURNING g_fia[l_ac].fjc03      
                  NEXT FIELD fjc03
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       #No.FUN-6B0029--begin                                             
       ON ACTION controls                                        
          CALL cl_set_head_visible("","AUTO")                    
       #No.FUN-6B0029--end 
    END INPUT
    IF INT_FLAG THEN  
       LET INT_FLAG = 0
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
    END IF
END FUNCTION
 
FUNCTION p100_bp(p_ud)
 
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_fia TO s_fia.* ATTRIBUTE(COUNT=g_rec_b) 
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
   ON ACTION confirm                                                        
      LET g_action_choice="detail"                                          
      LET l_ac = ARR_CURR()                                                 
      EXIT DISPLAY   
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
      LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
   ON ACTION locale
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
 
   ON ACTION exit
      LET g_action_choice="exit"
      RETURN 
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY
 
   ON ACTION about         #MOD-4C0121
      CALL cl_about()      #MOD-4C0121
 
   ON ACTION help          #MOD-4C0121
      CALL cl_show_help()  #MOD-4C0121
 
   ON ACTION controlg      #MOD-4C0121
      CALL cl_cmdask()     #MOD-4C0121
 
   # No.FUN-530067 --start--
   AFTER DISPLAY
      CONTINUE DISPLAY
   # No.FUN-530067 ---end---
 
#No.FUN-6B0029--begin                                             
   ON ACTION controls                                        
      CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
    
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION  p100_gen()
DEFINE  l_fim02   LIKE fim_file.fim02,
        l_fia20   LIKE fia_file.fia20,
        l_fia01   LIKE fia_file.fia01,
        l_fio05   LIKE fio_file.fio05,
        l_fjc03   LIKE fjc_file.fjc03,
        l_fio03   LIKE fio_file.fio03,
        l_fio04   LIKE fio_file.fio04,
        l_fio08   LIKE fio_file.fio08,
        l_fil01   LIKE fil_file.fil01,
        l_time   LIKE type_file.chr8,        
        l_n       LIKE type_file.chr1,       #No.FUN-680072 VARCHAR(1)
        g_i       LIKE type_file.num10,      #No.FUN-680072 INTEGER
        i         LIKE type_file.num10       #No.FUN-680072 INTEGER
DEFINE li_result      LIKE type_file.num5      #No.FUN-560014        #No.FUN-680072 SMALLINT
 
    DROP TABLE p100_temp
    CREATE TEMP TABLE p100_temp(
              fia01 LIKE fia_file.fia01,
              fia02 LIKE fia_file.fia02,                       
              fjc03 LIKE fjc_file.fjc03,                   
              fio05 LIKE fio_file.fio05,
              des   LIKE type_file.chr8,  
              fio06 LIKE fio_file.fio06,
              fiu02 LIKE fiu_file.fiu02,
              fio07 LIKE fio_file.fio07,
              fja02 LIKE fja_file.fja02,
              fio08 LIKE fio_file.fio08,
              fio03 LIKE fio_file.fio03,
              fio04 LIKE fio_file.fio04)
 
   FOR i=1 TO g_rec_b
     IF NOT cl_null(g_fia[i].fia01) THEN 
       INSERT INTO p100_temp VALUES(g_fia[i].*)
       IF SQLCA.sqlcode THEN                                         
#         CALL cl_err('insert p100_temp',SQLCA.sqlcode,1)                 #No.FUN-660092
          CALL cl_err3("ins","p100_temp","","",SQLCA.sqlcode,"","insert p100_temp",1)  #No.FUN-660092
          LET g_success='N'
          RETURN
       END IF
     END IF
   END FOR
   DECLARE p100_fia_cur CURSOR FOR                                           
    SELECT fia01,fio05 FROM p100_temp
     GROUP BY fia01,fio05                               
     ORDER BY fia01,fio05                                                      
   IF SQLCA.sqlcode THEN                                                       
      CALL cl_err('declare p100_fia_cur',SQLCA.sqlcode,0)                       
      LET g_success='N'
      RETURN                                                                   
   END IF                                                                      
   DECLARE p100_fia_b_cur CURSOR FOR                                           
    SELECT fjc03,fio03,fio04,fio08
      FROM p100_temp
     WHERE fia01=l_fia01 AND fio05=l_fio05
     ORDER BY fjc03                                 
   IF SQLCA.sqlcode THEN                                                       
      CALL cl_err('declare p100_fia_b_cur',SQLCA.sqlcode,0)                       
      LET g_success='N'
      RETURN                                                                   
   END IF                                                                      
 
    LET l_time = TIME 
    LET l_time = l_time[1,2],l_time[4,5]
    FOREACH p100_fia_cur INTO l_fia01,l_fio05                             
        IF SQLCA.sqlcode THEN                                                   
           CALL cl_err('foreach p100_fia_cur',SQLCA.sqlcode,0)                
           LET g_success='N'
           RETURN
        END IF  
 #No.MOD-560238 --start
#No.FUN-560014 --start--
#      CALL s_auto_assign_no("aem",g_fil01,g_today,"01","fil_file","fil01",   
       CALL s_auto_assign_no("aem",g_fil01,g_today,"1","fil_file","fil01",   
                  "","","")
            RETURNING li_result,l_fil01
        DISPLAY l_fil01 TO FORMONLY.f  
 #No.MOD-560238 --end  
       IF (NOT li_result) THEN
          LET g_success='N' 
          RETURN 
       END IF                                      
          
#      CALL s_smyauno(g_fil01,g_today) RETURNING g_i,l_fil01          
#       IF g_i
#No.FUN-560014 --end--  
#          THEN LET g_success='N' RETURN END IF                                      
        SELECT fia20 INTO l_fia20 FROM fia_file WHERE fia01 = l_fia01
        IF l_fia20 > g_today THEN
           LET l_n = 'Y'
        ELSE 
           LET l_n = 'N'
        END IF
        INSERT INTO fil_file(fil00,fil01,fil03,fil04,fil05,fil08,fil09,fil10,
                             fil11,fil12,fil13,fil14,fil141,fil16,filacti,
                             filconf,filuser,filgrup,fildate,
                             filplant,fillegal,filoriu,filorig) #FUN-980002
                     VALUES(l_fio05,l_fil01,l_fia01,g_fil04,'1',g_user,
                            g_grup,g_today,l_time,g_today,g_today,g_today,
                            l_time,l_n,'Y','N',g_user,g_grup,g_today,
                            g_plant,g_legal, g_user, g_grup) #FUN-980002      #No.FUN-980030 10/01/04  insert columns oriu, orig
       IF SQLCA.sqlcode THEN                                         
          CALL cl_err3("ins","fil_file",l_fil01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092 #No.FUN-B80026---調整至回滾事務前---
          ROLLBACK WORK                                         
#         CALL cl_err(g_fil01,SQLCA.sqlcode,0)                #No.FUN-660092
          LET g_success='N'
          RETURN
       END IF
 
       FOREACH p100_fia_b_cur INTO l_fjc03,l_fio03,l_fio04,l_fio08      
          IF SQLCA.sqlcode THEN                                         
             CALL cl_err('foreach p100_fia_b_cur',SQLCA.sqlcode,0)       
             LET g_success='N'
             RETURN
          END IF  
          SELECT max(fim02)+1 INTO l_fim02                             
           FROM fim_file                                                   
          WHERE fim01 = l_fil01
          IF l_fim02 IS NULL THEN                                 
             LET l_fim02 = 1                                      
          END IF
          INSERT INTO fim_file(fim01,fim02,fim03,fim04,fim06,fim07,fim08,fim11,
                               fimplant,fimlegal) #FUN-980002
                        VALUES(l_fil01,l_fim02,l_fjc03,g_today,
                               l_fio03,l_fio04,l_fio08, 'N',
                               g_plant,g_legal) #FUN-980002
          IF SQLCA.sqlcode THEN                                         
             LET g_success='N'
#            CALL cl_err('insert fim_file',SQLCA.sqlcode,0)                #No.FUN-660092
             CALL cl_err3("ins","fim_file",l_fil01,"",SQLCA.sqlcode,"","insert fim_file",1)  #No.FUN-660092
             RETURN
          END IF
       END FOREACH
    END FOREACH
END FUNCTION    
 
