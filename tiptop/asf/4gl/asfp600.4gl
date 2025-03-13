# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asfp600.4gl
# Descriptions...: 製程追蹤資料產生作業
# Input parameter: 
# Return code....: 
# Date & Author..: 92/08/07 By Pin   
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-710010 07/03/06 By pengu sfb93='N'的工單不可執行本程式
# Modify.........: No.TQC-770003 07/07/03 By zhoufeng 維護幫助按鈕
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0204 09/12/04 By lilingyu缺少事務,但是仍可插入數據
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-D70072 13/07/22 By lujh 1.“工單編號”，“生產料件”欄位建議增加開窗
#                                                 2.資料生成成功後，沒有任何的提示信息
#                                                 3.無法ctrl+g
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    l_cmd    LIKE type_file.chr1000,    #string command variable        #No.FUN-680121 VARCHAR(100)
          m_status LIKE type_file.chr1,       # Prog. Version..: '5.30.06-13.03.12(01)#reset version/effective/routing
                                              # Y/N  
        g_sfb DYNAMIC ARRAY OF RECORD            #
            sfb01  LIKE sfb_file.sfb01,       #W.O NO.
            sfb05  LIKE sfb_file.sfb05,       #part no.
            sfb07  LIKE sfb_file.sfb07,       #version no.
            sfb071 LIKE sfb_file.sfb071,      #effective date.
            sfb06  LIKE sfb_file.sfb06        #routing no.       
        END RECORD,
        g_cmd        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(60)
        g_rec_b      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        s_t          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_exit_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_ac,l_sl    LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680121 INTEGER
DEFINE   g_chr           LIKE type_file.chr1       #MOD-9B0204
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
   IF g_sma.sma26 ='1' THEN 
      CALL cl_err(g_sma.sma26,'mfg6182',1)
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   CALL p600_cmd(0,0)          #condition input
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION p600_cmd(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_flag         LIKE type_file.chr1     #TQC-D70072 add
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p600_w AT p_row,p_col WITH FORM "asf/42f/asfp600" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      CALL g_sfb.clear()
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
      CONSTRUCT l_cmd ON sfb01,sfb05 FROM wo_no,part_no  #QBE 輸入條件
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      ON ACTION help
         CALL cl_show_help()
      
      #TQC-D70072--add--str--
      ON ACTION controlp
           CASE
              WHEN INFIELD(wo_no)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO wo_no
                  NEXT FIELD wo_no
              WHEN INFIELD(part_no)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb05_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO part_no
                  NEXT FIELD part_no
              OTHERWISE
                 EXIT CASE
           END CASE

      ON ACTION controlg
         CALL cl_cmdask()
      #TQC-D70072--add--end--
      END CONSTRUCT
      LET l_cmd = l_cmd CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
      IF INT_FLAG THEN LET INT_FLAG = 0 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM  
      END IF
 
      #CALL p600_bp()
#----->第二階段以輸入方式輸入
      LET m_status='N'
      INPUT m_status FROM c 
         AFTER FIELD c
            IF m_status IS NULL THEN 
               NEXT FIELD  c 
            END IF  
            IF m_status NOT MATCHES '[yYnN]' THEN
               NEXT FIELD m_status
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION help
            CALL cl_show_help()
     
      END INPUT
      IF INT_FLAG THEN LET INT_FLAG = 0 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM  
      END IF
      CALL p600_fill() returning s_t
      IF s_t <=0 THEN
         CALL cl_err( ' ','mfg3122',0)
         CONTINUE  WHILE
      END IF
      CALL p600_bp()
      IF m_status MATCHES '[Yy]' THEN 
         CALL p600_array() 
      END IF
      IF NOT cl_sure(0,0) THEN
         EXIT  WHILE
      END IF
      CALL p600_gen() 

      #TQC-D70072--add--str--
      IF g_chr = 'Y' THEN 
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
      #TQC-D70072--add--end--
   END WHILE
   ERROR ""
   CLOSE WINDOW p600_w
END FUNCTION
 
FUNCTION p600_fill()
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0090
      DEFINE   l_wc   LIKE type_file.chr1000,    # RDSQL STATEMENT  #No.FUN-680121 VARCHAR(200)   #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,         # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(600) 
          l_no,l_cnt    LIKE type_file.num5                                  #No.FUN-680121 SMALLINT
 
   UPDATE sfb_file SET sfb071=' ' WHERE sfb071 IS NULL
   LET l_sql = "  SELECT sfb01,sfb05,sfb07,sfb071,sfb06 ",
               "  FROM sfb_file",
               "  WHERE sfb04='1' ",                 #確認工單
               "    AND sfb24 NOT IN ('y','Y') ",  #未產生製程資料
               "    AND sfbacti='Y' " ,              #有效之資料
               "    AND sfb93 = 'Y' ",               #No.TQC-710010 add
               "    AND sfb01 NOT IN (select ecm01 from ecm_file) ",
               "    AND sfb02 !=5 AND sfb02 !=11 AND sfb87!='X' ",
               "    AND ",l_cmd clipped,
               "    ORDER BY sfb071 "
 
   PREPARE p600_prepare FROM l_sql #prepare it
   DECLARE p600_cur CURSOR FOR p600_prepare
   LET l_ac = 1
   FOR l_ac=1 TO g_sfb.getLength()
      INITIALIZE g_sfb[l_ac].* TO NULL
   END FOR
   LET l_ac = 1
   FOREACH p600_cur INTO g_sfb[l_ac].* 
      IF SQLCA.sqlcode THEN 
         CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)  
         EXIT FOREACH
      END IF
      CALL SET_COUNT(l_ac)
      LET g_rec_b=l_ac 
         DISPLAY g_rec_b TO FORMONLY.cn2  
         LET g_cnt = 0
      LET l_ac = l_ac + 1
      LET l_cnt = l_cnt + 1
     #TQC-630106-begin 
      #IF l_ac > g_max_rec THEN EXIT FOREACH END IF
      IF l_ac > g_max_rec THEN 
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
     #TQC-630106-end 
   END FOREACH
   CALL SET_COUNT(l_ac - 1)
   RETURN l_cnt
END FUNCTION
   
FUNCTION p600_array()
   DEFINE
      l_n,l_ac,l_sl    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
      xx               LIKE type_file.dat,           #No.FUN-680121 DATE
      l_return         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
      l_effect,l_loss  LIKE type_file.dat,           #No.FUN-680121 DATE
      ss               LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
      l_exit_sw        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
      l_allow_insert   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#可新增否
      l_allow_delete   LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)#可刪除否
 
 
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
 
   INPUT ARRAY g_sfb WITHOUT DEFAULTS FROM s_sfb.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW =FALSE ,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_sl = SCR_LINE()
         DISPLAY l_ac TO FORMONLY.cn3  
      AFTER FIELD sfb07
         IF g_sfb[l_ac].sfb07 IS NOT NULL  AND g_sfb[l_ac].sfb01
            IS NOT NULL AND g_sfb[l_ac].sfb05 IS NOT NULL
            AND g_sfb[l_ac].sfb07 !=' ' THEN
            CALL s_version(g_sfb[l_ac].sfb05,g_sfb[l_ac].sfb07)
             RETURNING l_effect,l_loss,l_return
            DISPLAY g_sfb[l_ac].sfb071 TO s_sfb[l_sl].sfb071
            IF l_return = 1 THEN 
               CALL cl_err(g_sfb[l_ac].sfb07,'mfg6160',0)
               NEXT FIELD sfb07
            END IF
            LET g_sfb[l_ac].sfb071 = l_effect
            DISPLAY g_sfb[l_ac].sfb071 TO s_sfb[l_sl].sfb071
            LET ss='Y'
         ELSE
            LET  ss='N'
         END IF
 
      AFTER FIELD  sfb071
         IF g_sfb[l_ac].sfb01 IS NOT NULL 
            AND g_sfb[l_ac].sfb05 IS NOT NULL THEN
            IF g_sfb[l_ac].sfb071 IS NULL THEN 
               CALL cl_err(g_sfb[l_ac].sfb071,'mfg6150',0)
               NEXT FIELD sfb071
            ELSE
               IF l_effect IS NOT NULL AND l_loss IS NOT NULL AND ss='Y' THEN 
                  IF g_sfb[l_ac].sfb071 < l_effect OR 
                     g_sfb[l_ac].sfb071 >= l_loss THEN
                     CALL cl_err(g_sfb[l_ac].sfb071,'mfg6161',0)
                     NEXT FIELD sfb071
                  END IF
               END IF
            END IF
         END IF
            
      AFTER FIELD sfb06
         IF g_sfb[l_ac].sfb06 IS NULL AND g_sfb[l_ac].sfb01 IS NOT NULL 
            AND g_sfb[l_ac].sfb05 IS NOT NULL THEN
            CALL cl_err(g_sfb[l_ac].sfb06,'mfg6154',0)
            NEXT FIELD sfb06
         END IF
         IF NOT cl_null(g_sfb[l_ac].sfb01) AND 
            NOT cl_null(g_sfb[l_ac].sfb05) AND 
            NOT cl_null(g_sfb[l_ac].sfb071) AND 
            NOT cl_null(g_sfb[l_ac].sfb06) THEN
            IF NOT s_rutchk(g_sfb[l_ac].sfb05,
               g_sfb[l_ac].sfb06,g_sfb[l_ac].sfb071) THEN
               NEXT FIELD sfb071
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
                
      
      #TQC-D70072--add--str--
      ON ACTION help
         CALL cl_show_help()
      #TQC-D70072--add--end--

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END   
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION p600_bp()
 
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         IF m_status MATCHES '[Yy]' THEN
              EXIT DISPLAY
           END IF
 
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
 
       ON ACTION exit        LET g_action_choice="exit"       RETURN 
 
       ON ACTION help
          CALL cl_show_help()         #No.TQC-770003
 
       #TQC-D70072--add--str--
       ON ACTION controlg
            CALL cl_cmdask()
       #TQC-D70072--add--end--

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
    
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#---->generate routing tracking file 
FUNCTION  p600_gen()
   DEFINE  
      i   LIKE type_file.num5,          #dimension point        #No.FUN-680121 SMALLINT
      l_msg LIKE ze_file.ze03,          #No.FUN-680121 VARCHAR(10)#message string
      t_msg LIKE type_file.chr1000,     #No.FUN-680121 VARCHAR(70)#message string
      p_status LIKE type_file.num10,    #No.FUN-680121 INTEGER #return valiable
      g_type,g_track LIKE type_file.chr1,           #No.FUN-680121 VARCHAR(1)
      x_sfb13,x_sfb15 LIKE type_file.dat,           #No.FUN-680121 DATE
      l_sfb13,l_sfb15 LIKE type_file.dat,           #No.FUN-680121 DATE
      l_sfb08 LIKE sfb_file.sfb08,
      g_cnt   LIKE type_file.num5,                  #No.FUN-680121 SMALLINT
      p_chr   LIKE type_file.chr1                   #No.FUN-680121 VARCHAR(1)#answer Y/N
 

    BEGIN WORK       #MOD-9B0204
    LET g_chr = 'Y'  #MOD-9B0204
   FOR i=1 TO g_sfb.getLength()
      IF g_sfb[i].sfb01 IS NULL OR  g_sfb[i].sfb05 IS NULL THEN 
         CONTINUE FOR
      END IF
      IF NOT s_rutchk1(g_sfb[i].sfb05,g_sfb[i].sfb06,g_sfb[i].sfb071) THEN
         OPEN WINDOW p600_w2 AT 18,2 WITH 1 ROWS, 70 COLUMNS
          
         CALL cl_getmsg('mfg6151',g_lang) RETURNING l_msg
         CALL cl_getmsg('mfg6162',g_lang) RETURNING t_msg
            LET INT_FLAG = 0  ######add for prompt bug
         PROMPT l_msg clipped,g_sfb[i].sfb01,' ',t_msg clipped FOR CHAR p_chr
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
#               CONTINUE PROMPT
         
         END PROMPT
         IF INT_FLAG THEN
            LET INT_FLAG=0 
            CLOSE WINDOW p600_w2
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM 
         END IF
         IF p_chr MATCHES '[nN]' THEN 
            CLOSE WINDOW p600_w2 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM 
         END IF
         CONTINUE FOR
      END IF

#MOD-9B0204 --begin--
#      CALL s_genrut(g_sfb[i].sfb01,g_sfb[i].sfb05,g_sfb[i].sfb071,
#       g_sfb[i].sfb06) RETURNING p_status
#      IF NOT p_status THEN 
#         CALL cl_err(p_status,'mfg6152',1)
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
#         EXIT PROGRAM
#      END IF
#MOD-9B0204 --end--

      SELECT sfb08,sfb13,sfb15 INTO l_sfb08,l_sfb13,l_sfb15 FROM sfb_file 
       WHERE sfb01=g_sfb[i].sfb01
      CALL s_schdat(0,l_sfb13,l_sfb15,g_sfb[i].sfb071,g_sfb[i].sfb01,
           g_sfb[i].sfb06,'1',g_sfb[i].sfb05,l_sfb08,'1')
        RETURNING g_cnt,x_sfb13,x_sfb15,g_type,g_track
        IF g_cnt < 1 THEN #error detected
            CALL cl_err(g_cnt,'asf-311',0)
            LET g_chr = 'N' #MOD-9B0204
            ROLLBACK WORK   #MOD-9B0204
        END IF
 
IF g_chr = 'Y' THEN   #MOD-9B0204
   UPDATE sfb_file SET sfb24='Y',
                       sfb07=g_sfb[i].sfb07,
                       sfb071=g_sfb[i].sfb071,
                       sfb06=g_sfb[i].sfb06
                       WHERE sfb01=g_sfb[i].sfb01
END IF               #MOD-9B0204
 END FOR
COMMIT WORK          #MOD-9B0204
END FUNCTION
 
