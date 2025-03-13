# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: anmi102.4gl
# Descriptions...: 銀行假日設定作業
# Input parameter: 
# Return code....: 
# Date & Author..: 95/09/12 By Danny
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制   
# Modify.........: No.FUN-590127 05/10/17 By Smapmin 增加報表列印功能
# Modify.........: No.TQC-630104 06/03/14 By Smapmin DISPLAY ARRAY 無控制單身筆數
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-790050 07/07/13 By Carrier _out()轉p_query實現
# Modify.........: No.MOD-960075 09/06/09 By baofei 4fd沒有cn2這個欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_nph           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nph01       LIKE nph_file.nph01,  
        nph02       LIKE nph_file.nph02   
                    END RECORD,
    g_nph_t         RECORD                     #程式變數 (舊值)
        nph01       LIKE nph_file.nph01,  
        nph02       LIKE nph_file.nph02   
                    END RECORD,
    g_wc,g_sql      STRING,                    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數 #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(72)
DEFINE g_before_input_done LIKE type_file.num5 #FUN-570108 #No.FUN-680107 SMALLINT
 
 
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5        #No.FUN-680107 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
    LET p_row = 4 LET p_col = 20
    OPEN WINDOW i102_w AT p_row,p_col
        WITH FORM "anm/42f/anmi102" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
#    CALL i102_bf(' 1=1')   #FUN-590127
    LET g_wc = '1=1' CALL i102_bf(g_wc)   #FUN-590127
    CALL i102_menu()
    CLOSE WINDOW i102_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION i102_menu()
 
   WHILE TRUE
      CALL i102_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i102_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i102_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#FUN-590127
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i102_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "anmi102" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
#END FUN-590127
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nph),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i102_q()
   CALL i102_b_askkey()
END FUNCTION
 
#單身
FUNCTION i102_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重複用        #No.FUN-680107 SMALLINT
    l_cnt           LIKE type_file.num5,         #檢查重複用        #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否        #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態          #No.FUN-680107 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否          #No.FUN-680107 VARCHAR(1)                  
    l_allow_delete  LIKE type_file.num5          #可刪除否          #No.FUN-680107 VARCHAR(1)                  
 
    LET g_action_choice = ""                                                    
    IF s_anmshut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')               
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT nph01,nph02 FROM nph_file WHERE nph01= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_nph WITHOUT DEFAULTS FROM s_nph.* 
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)   
 
        BEFORE INPUT                                                            
         IF g_rec_b!=0 THEN
          CALL fgl_set_arr_curr(l_ac)                                           
         END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
           #LET g_nph_t.* = g_nph[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_nph_t.nph01 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_nph_t.* = g_nph[l_ac].*  #BACKUP
#No.FUN-570108 --start                                                          
                LET g_before_input_done = FALSE                                 
                CALL i102_set_entry(p_cmd)                                      
                CALL i102_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end                  
                BEGIN WORK
                OPEN i102_bcl USING g_nph_t.nph01
                IF STATUS THEN
                   CALL cl_err("OPEN i102_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i102_bcl INTO g_nph[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_nph_t.nph01,SQLCA.sqlcode,1)  
                      LET l_lock_sw = "Y"
                   ELSE
                      LET g_nph_t.*=g_nph[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
         #NEXT FIELD nph01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i102_set_entry(p_cmd)                                          
            CALL i102_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108 --end       
            LET g_nph_t.* = g_nph[l_ac].*         #新輸入資料
            INITIALIZE g_nph[l_ac].* TO NULL      #900423
            CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD nph01
 
        AFTER INSERT                                                            
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
            # CLOSE i102_bcl                                                   
            # CALL g_nph.deleteElement(l_ac)                                   
            # IF g_rec_b != 0 THEN                                             
            #     LET g_action_choice = "detail"                                
            #     LET l_ac = l_ac_t                                             
            # END IF                                                           
            # EXIT INPUT
           END IF
           INSERT INTO nph_file(nph01,nph02)
           VALUES(g_nph[l_ac].nph01,g_nph[l_ac].nph02)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_nph[l_ac].nph01,SQLCA.sqlcode,0)   #No.FUN-660148
              CALL cl_err3("ins","nph_file",g_nph[l_ac].nph01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
             #LET g_nph[l_ac].* = g_nph_t.*
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
#              DISPLAY g_rec_b TO FORMONLY.cn2  #MOD-960075
            END IF
 
        AFTER FIELD nph01
          IF g_nph[l_ac].nph01 != g_nph_t.nph01 OR
             (NOT cl_null(g_nph[l_ac].nph01) AND cl_null(g_nph_t.nph01)) THEN
             SELECT COUNT(*) INTO l_cnt FROM nph_file
              WHERE nph01 = g_nph[l_ac].nph01
                AND nph02 = g_nph[l_ac].nph02 
             IF l_cnt > 0 THEN 
                CALL cl_err('',-239,0) 
                LET g_nph[l_ac].nph01 = g_nph_t.nph01
                NEXT FIELD nph01
             END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_nph_t.nph01 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM nph_file
                 WHERE nph01 = g_nph_t.nph01 
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_nph_t.nph01,SQLCA.sqlcode,0)   #No.FUN-660148
                   CALL cl_err3("del","nph_file",g_nph_t.nph01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
#                DISPLAY g_rec_b TO FORMONLY.cn2   #MOD-960075
                MESSAGE "Delete OK"                                             
                CLOSE i102_bcl         
                COMMIT WORK
            END IF
 
        ON ROW CHANGE                                                           
          IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_nph[l_ac].* = g_nph_t.*
               CLOSE i102_bcl   
               ROLLBACK WORK     
               EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN                                               
             CALL cl_err(g_nph[l_ac].nph01,-263,1)                            
             LET g_nph[l_ac].* = g_nph_t.*                                      
          ELSE                                      
             UPDATE nph_file SET nph01=g_nph[l_ac].nph01,
                                 nph02=g_nph[l_ac].nph02 
              WHERE nph01 = g_nph_t.nph01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_nph[l_ac].nph01,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","nph_file",g_nph_t.nph01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_nph[l_ac].* = g_nph_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i102_bcl         
             END IF
          END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_nph[l_ac].* = g_nph_t.*
            #FUN-D30032--add--str--
              ELSE
                 CALL g_nph.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30032--add--end--
              END If
              CLOSE i102_bcl  
              ROLLBACK WORK  
              EXIT INPUT
           END IF
          #LET g_nph_t.* = g_nph[l_ac].*          # 900423
           LET l_ac_t = l_ac    
           CLOSE i102_bcl      
           COMMIT WORK  
 
        ON ACTION CONTROLN
            CALL i102_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(nph01) AND l_ac > 1 THEN
                LET g_nph[l_ac].* = g_nph[l_ac-1].*
                NEXT FIELD nph01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
 
    CLOSE i102_bcl
    COMMIT WORK
END FUNCTION
   
FUNCTION i102_b_askkey()
#DEFINE l_wc      LIKE type_file.chr1000  #MOD-590127 #No.FUN-680107 VARCHAR(200)
 
    CLEAR FORM
   CALL g_nph.clear()
#    CONSTRUCT l_wc ON nph01,nph02   #FUN-590127
    CONSTRUCT g_wc ON nph01,nph02   #FUN-590127
                 FROM s_nph[1].nph01,s_nph[1].nph02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
#    CALL i102_bf(l_wc)   #FUN-590127
    CALL i102_bf(g_wc)   #FUN-590127
END FUNCTION
 
FUNCTION i102_bf(p_wc)              #BODY FILL UP
DEFINE
    p_wc  LIKE type_file.chr1000    #No.FUN-680107 VARCHAR(200)
 
    LET g_sql =
       "SELECT nph01,nph02",
       "  FROM nph_file ",
       " WHERE ",p_wc CLIPPED,
       " ORDER BY nph01 "
    PREPARE i102_prepare2 FROM g_sql      #預備一下
    DECLARE nph_cs CURSOR FOR i102_prepare2
    FOR g_cnt = 1 TO g_nph.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_nph[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH nph_cs INTO g_nph[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        #-----TQC-630104---------
        IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
        #-----END TQC-630104-----
    END FOREACH
    CALL g_nph.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1         
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION i102_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nph TO s_nph.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
#FUN-590127
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
#END FUN-590127
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
                                                                                
      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-790050  --Begin
##FUN-590127
#FUNCTION i102_out()
#    DEFINE
#        l_nph01         LIKE nph_file.nph01,
#        l_nph02         LIKE nph_file.nph02,
#        l_name          LIKE type_file.chr20    # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#
#    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#    CALL cl_wait()
#    CALL cl_outnam('anmi102') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT nph01,nph02 ",
#              "  FROM nph_file ",
#              " WHERE ",g_wc CLIPPED ,
#              " ORDER BY nph01 "
#    PREPARE i102_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i102_co CURSOR FOR i102_p1
#
#    START REPORT i102_rep TO l_name
#
#    FOREACH i102_co INTO l_nph01,l_nph02
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i102_rep(l_nph01,l_nph02)
#    END FOREACH
#
#    FINISH REPORT i102_rep
#
#    CLOSE i102_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i102_rep(l_nph01,l_nph02)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
#        l_nph01         LIKE nph_file.nph01,
#        l_nph02         LIKE nph_file.nph02
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY l_nph01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31],g_x[32]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            PRINT COLUMN g_c[31],l_nph01,
#                  COLUMN g_c[32],l_nph02
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
##END FUN-590127
#No.FUN-790050  --End  
 
#No.FUN-570108 --start                                                          
FUNCTION i102_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
     CALL cl_set_comp_entry("nph01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i102_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("nph01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end             
