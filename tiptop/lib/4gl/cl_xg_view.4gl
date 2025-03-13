# Prog. Version..: '5.30.07-13.05.16(00008)'     #
# Library name...: cl_xg_view
# Descriptions...: 執行開啟XtraGrid報表
# Date & Author..: FUN-C10034 12/10/01 by odyliao 
# Modify.........: FUN-CA0154 調整增加 g_xgrid.sql 與相關邏輯
# Modify.........: FUN-CB0101 新增動態標題
# Modify.........: FUN-CC0039 優先取用使用者慣用群組/排序
# Modify.........: FUN-CC0115 1.新增模板(有單頭+圖表)與相關邏輯 2.增加背景作業處理
# Modify.........: FUN-D20057 新增匯出相關欄位與權限控管
# Modify.........: FUN-D30045 修正跳頁的判斷與錯誤控制
# Modify.........: FUN-D30056 調整 cl_get_order_field，使其可判斷英文字(ABC...)的選項
# Modify.........: FUN-D40059 1.增加無logo時的判斷 2.修正報表預設title2
 
IMPORT os
IMPORT com
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS 
   DEFINE gs_hostname   STRING    #AP SERVER Host Name   #FUN-C10034
   DEFINE g_report        LIKE type_file.chr20 
   DEFINE g_zz011         LIKE zz_file.zz011
   DEFINE lc_sys_a        STRING   #modify lc_sys by guanyao160524
   DEFINE channel         base.Channel
   DEFINE g_errlog        DYNAMIC ARRAY OF STRING
END GLOBALS

 
##################################################
# Input parameter: p_wc - 列印條件(會印在報表尾的資訊)
# Usage .........: call cl_xg_view(p_skip)
##################################################
 
FUNCTION cl_xg_view()
DEFINE l_url   STRING
DEFINE res     LIKE type_file.num10
DEFINE l_zo02  LIKE zo_file.zo02
DEFINE l_gaz03 LIKE gaz_file.gaz03
DEFINE l_gaz06 LIKE gaz_file.gaz06
DEFINE l_cond  STRING
DEFINE l_gdq   RECORD LIKE gdq_file.*
DEFINE l_time  LIKE type_file.chr1000
DEFINE l_gdr   RECORD LIKE gdr_file.*
DEFINE l_gdr00 LIKE gdr_file.gdr00
DEFINE l_gdr06 LIKE gdr_file.gdr06
DEFINE l_gdr10 LIKE gdr_file.gdr10
DEFINE l_gdr11 LIKE gdr_file.gdr11
DEFINE l_gdr12 LIKE gdr_file.gdr12
DEFINE l_gdr16 LIKE gdr_file.gdr16
DEFINE l_grups LIKE gdr_file.gdr16
DEFINE l_gdr17 LIKE gdr_file.gdr17
DEFINE l_cnt,l_n,l_n2   LIKE type_file.num10
DEFINE l_gdq15 LIKE gdq_file.gdq15
DEFINE l_gdq16 LIKE gdq_file.gdq16
DEFINE l_flag  LIKE type_file.chr1
DEFINE l_certid      STRING
DEFINE l_sql   STRING
DEFINE l_sql2  STRING
DEFINE l_subrep LIKE type_file.chr1000
DEFINE lst_token base.StringTokenizer
DEFINE ls_token  STRING
DEFINE l_tables  DYNAMIC ARRAY OF STRING   
DEFINE l_gds18   LIKE gds_file.gds18
DEFINE l_gds03   LIKE gds_file.gds03
DEFINE l_gds28   LIKE gds_file.gds28
DEFINE l_gds19   LIKE gds_file.gds19
DEFINE l_gen02   LIKE gen_file.gen02
DEFINE l_str     STRING
DEFINE l_x       LIKE type_file.chr1000
DEFINE l_flds    DYNAMIC ARRAY OF STRING
DEFINE l_fld     LIKE type_file.chr1000
DEFINE l_fldstr  STRING
DEFINE l_logourl  STRING
DEFINE l_logopath STRING
DEFINE l_tmps    DYNAMIC ARRAY OF RECORD
                     gdr00  LIKE gdr_file.gdr00, #樣板ID
                     gdr06  LIKE gdr_file.gdr06, #報表型態
                     gdr10  LIKE gdr_file.gdr10, #風格主題
                     gdr11  LIKE gdr_file.gdr11, #圖表類型
                     gdr12  LIKE gdr_file.gdr12  #圖表軸數
                    ,gdr02  LIKE gdr_file.gdr02  #樣板代號 #FUN-D40059
                    ,gdr04  LIKE gdr_file.gdr04  #使用者   #FUN-D40059
                    ,gdr05  LIKE gdr_file.gdr05  #權限類別 #FUN-D40059
                 END RECORD

    CALL g_errlog.clear()

   #拆解 Table (子報表部份拆解到 gdq33)
    LET lst_token = base.StringTokenizer.create(g_xgrid.table, "|")
    LET l_n = 1
    WHILE lst_token.hasMoreTokens()
       LET l_tables[l_n] = lst_token.nextToken()
       LET l_n = l_n + 1
    END WHILE
    LET l_n = l_n - 1 #多加一筆，扣回來
    LET g_xgrid.table = l_tables[1]
    IF l_n >= 2 THEN
       LET l_gdq.gdq33 = NULL
       FOR l_cnt = 2 TO l_tables.getlength()
           IF cl_null(l_tables[l_cnt]) THEN CONTINUE FOR END IF
           LET l_gdq.gdq33 = l_gdq.gdq33 CLIPPED,l_tables[l_cnt] CLIPPED,'|'
       END FOR
       IF LENGTH(l_gdq.gdq33) > 1 THEN
          LET l_gdq.gdq33 = l_gdq.gdq33[1,LENGTH(l_gdq.gdq33)-1]
       END IF
    END IF
   #DISPLAY "sub_report:",l_gdq.gdq33

   #FUN-CA0154 --start--
    IF cl_null(g_xgrid.sql) THEN
       LET l_cnt = cl_gre_rowcnt(g_xgrid.table)
       IF l_cnt = 0 THEN RETURN END IF
       LET l_gdq.gdq03 = g_xgrid.table
    ELSE
      #For cs1() 架構
       LET l_x = g_xgrid.sql
       LET l_n = g_xgrid.sql.getIndexOf("FROM",1)
       LET l_n2= g_xgrid.sql.getIndexOf("WHERE",1)
       LET l_gdq.gdq03 = l_x[l_n+4,l_n2-1]
       LET l_str = l_gdq.gdq03
       LET l_gdq.gdq03 = l_str.trim()
       IF l_n2 > 0 THEN
          LET l_gdq.gdq15 = l_x[l_n2+5,LENGTH(g_xgrid.sql)]
       ELSE
          LET l_gdq.gdq15 = ' 1=1'
       END IF
       #DISPLAY "WHERE CONDTION : ",l_gdq.gdq15
       LET l_cnt = cl_xg_rowcnt(l_gdq.gdq03,l_gdq.gdq15)
       IF l_cnt = 0 THEN RETURN END IF
    END IF
   #FUN-CA0154 --end--
  
    IF cl_null(gs_hostname) THEN
       LET gs_hostname = cl_used_ap_hostname()
    END IF

    CALL cl_set_xg_url() RETURNING l_certid,l_url,l_gdq16

    LET l_time = TIME
    LET l_gdr00 = NULL
    IF cl_null(g_xgrid.prog) THEN LET g_xgrid.prog = g_prog END IF
    #LET l_sql = "SELECT UNIQUE gdr00,gdr06,gdr10,gdr11,gdr12 ",
    LET l_sql = "SELECT UNIQUE gdr00,gdr06,gdr10,gdr11,gdr12,gdr02,gdr04,gdr05 ", #FUN-D40059 add gdr02,gdr04,gdr05
                "  FROM gdr_file,gds_file ",
                " WHERE gdr00 = gds00 ",
                "   AND gds02 = ",g_lang,
                "   AND (gdr04 = '",g_user,"' OR gdr05 = '",g_clas,"')",
                "   AND gdr03 = 'Y'"
    IF cl_null(g_xgrid.prog) THEN 
       LET g_xgrid.prog = g_prog
    END IF
    LET l_sql2 = " AND gdr01 ='",g_xgrid.prog,"'"
    IF NOT cl_null(g_xgrid.template) THEN 
       LET l_str = g_xgrid.template
       LET l_cnt = l_str.getIndexOf("|",1) 
       IF l_cnt > 0 THEN
          LET l_str = cl_replace_str(l_str,"|","','")
          LET l_sql2 = l_sql2 CLIPPED," AND gdr02 IN ('",l_str,"')"
       ELSE
          LET l_sql2 = l_sql2 CLIPPED," AND gdr02 ='",g_xgrid.template,"'"
       END IF
    END IF
    LET l_sql = l_sql, l_sql2
    PREPARE gdr_pre1 FROM l_sql
    DECLARE gdr_cur1 CURSOR FOR gdr_pre1

    #LET l_sql = "SELECT UNIQUE gdr00,gdr06,gdr10,gdr11,gdr12 ",
    LET l_sql = "SELECT UNIQUE gdr00,gdr06,gdr10,gdr11,gdr12,gdr02,gdr04,gdr05 ", #FUN-D40059 add gdr02,gdr04,gdr05
                "  FROM gdr_file,gds_file ",
                " WHERE gdr00 = gds00 ",
                "   AND gds02 = ",g_lang,
                "   AND gdr04 = 'default'",
                "   AND gdr05 = 'default'"
    LET l_sql = l_sql,l_sql2
    PREPARE gdr_pre2 FROM l_sql
    DECLARE gdr_cur2 CURSOR FOR gdr_pre2

    LET l_cnt = 1
   #先取此 user 的樣板 (非標準)
    FOREACH gdr_cur1 INTO l_tmps[l_cnt].*
        IF STATUS THEN CALL cl_err('gdr_cur1',STATUS,1) END IF
        LET l_cnt = l_cnt + 1
    END FOREACH
   #再取標準的(default)
    FOREACH gdr_cur2 INTO l_tmps[l_cnt].*
        IF STATUS THEN CALL cl_err('gdr_cur1',STATUS,1) END IF
        LET l_cnt = l_cnt + 1
    END FOREACH
    LET l_flag = 'N'
    LET g_success = 'Y'
    FOR l_n = 1 TO l_tmps.getlength()
      IF cl_null(l_tmps[l_n].gdr00) THEN CONTINUE FOR END IF
      CALL cl_xg_chk_column(l_tmps[l_n].gdr00,g_xgrid.sql,l_gdq.gdq03,l_gdq.gdq15)
      IF g_success = 'N' THEN EXIT FOR END IF
      #FUN-CC0039 --start--
      IF l_flag = 'N' THEN
         SELECT gdr16,gdr17 INTO l_gdr16,l_gdr17 
           FROM gdr_file
          WHERE gdr00 = l_tmps[l_n].gdr00
         LET l_flag = 'Y'
         LET l_gdr00 = l_tmps[l_n].gdr00
      #FUN-D20057 -- (s)取得逾時設定，以首筆樣板的設定為主
         SELECT gdr21 INTO l_gdq.gdq44 FROM gdr_file
          WHERE gdr00 = l_gdr00
      #FUN-D20057 -- (e)
      END IF
      #FUN-CC0039 --end--

      LET l_gdr06 = l_tmps[l_n].gdr06
      LET l_gdr10 = l_tmps[l_n].gdr10
      LET l_gdr11 = l_tmps[l_n].gdr11
      LET l_gdr12 = l_tmps[l_n].gdr12
      #LET l_gdq.gdq02 = l_gdq.gdq02 CLIPPED,l_gdr00 USING '<<<<','|'
      LET l_gdq.gdq02 = l_gdq.gdq02 CLIPPED,l_tmps[l_n].gdr00 USING '<<<<','|'
      CASE l_gdr06
        WHEN "1" 
           IF NOT cl_null(l_gdr11) THEN
              CASE l_gdr11
                WHEN "1" LET l_gdq.gdq17 = l_gdq.gdq17 CLIPPED,cl_getmsg('azz1283',g_lang) #明細清單(長條圖)
                WHEN "2" LET l_gdq.gdq17 = l_gdq.gdq17 CLIPPED,cl_getmsg('azz1284',g_lang) #明細清單(圓餅圖)
                WHEN "3" LET l_gdq.gdq17 = l_gdq.gdq17 CLIPPED,cl_getmsg('azz1285',g_lang) #明細清單(雷達圖)
              END CASE
           ELSE
              LET l_gdq.gdq17 = l_gdq.gdq17 CLIPPED,cl_getmsg('azz1287',g_lang)  #"明細清單|"
           END IF
        WHEN "2" LET l_gdq.gdq17 = l_gdq.gdq17 CLIPPED,cl_getmsg('azz1288',g_lang) #"明細清單(有單頭)|"
        WHEN "3" LET l_gdq.gdq17 = l_gdq.gdq17 CLIPPED,cl_getmsg('azz1289',g_lang) #"明細清單(子報表)|"
        WHEN "4" LET l_gdq.gdq17 = l_gdq.gdq17 CLIPPED,cl_getmsg('azz1290',g_lang) #"明細清單(單頭)(子報表)|"
        WHEN "5" LET l_gdq.gdq17 = l_gdq.gdq17 CLIPPED,cl_getmsg('azz1291',g_lang) #"交叉表|"
        WHEN "6" LET l_gdq.gdq17 = l_gdq.gdq17 CLIPPED,cl_getmsg('azz1292',g_lang) #"樹狀表|"
      END CASE
     #FUN-D40059---start
      LET l_gdq.gdq17 = l_gdq.gdq17,"[",cl_getmsg('azz1319',g_lang),":",l_tmps[l_n].gdr02," ",
                                        cl_getmsg('lib-036',g_lang),":",l_tmps[l_n].gdr04," ",
                                        cl_getmsg('azz1320',g_lang),":",l_tmps[l_n].gdr05,"|"
     #FUN-D40059---end
      LET l_gdq.gdq18 = l_gdq.gdq18 CLIPPED,l_gdr10 CLIPPED,'|' #風格
      IF cl_null(g_xgrid.sql) THEN
        IF NOT cl_null(l_gdr11) THEN
           CASE l_gdr06 
             WHEN "1" LET l_gdq.gdq14 = l_gdq.gdq14 CLIPPED,'template11.aspx','|'
             WHEN "2" LET l_gdq.gdq14 = l_gdq.gdq14 CLIPPED,'template12.aspx','|'
             OTHERWISE 
                 CALL cl_err('','azz1298',1)
                 CALL cl_xg_view_addlog(cl_getmsg('azz1298',g_lang)) #FUN-D20057
                 LET g_success = 'N' 
                 EXIT FOR
                 #RETURN
           END CASE
        ELSE
           LET l_gdq.gdq14 = l_gdq.gdq14 CLIPPED,'template',l_gdr06 USING '#','.aspx','|'
        END IF
      ELSE
        CASE l_gdr06
           WHEN "1" LET l_gdq.gdq14 = l_gdq.gdq14 CLIPPED,'template21.aspx','|'
           WHEN "2" LET l_gdq.gdq14 = l_gdq.gdq14 CLIPPED,'template22.aspx','|'
        END CASE
      END IF
    END FOR
    #IF g_success = 'N' THEN RETURN END IF
    IF cl_null(l_gdr00) THEN
       CALL cl_err('','azz1270',1)
       CALL cl_xg_view_addlog(cl_getmsg('azz1270',g_lang)) #FUN-D20057
       #RETURN
       LET g_success = 'N'
    END IF
    IF g_success = 'N' THEN 
       CALL cl_xg_view_logfile()
       RETURN 
    END IF

    LET l_gdq.gdq02 = l_gdq.gdq02[1,LENGTH(l_gdq.gdq02)-1]
    LET l_gdq.gdq14 = l_gdq.gdq14[1,LENGTH(l_gdq.gdq14)-1]
    LET l_gdq.gdq17 = l_gdq.gdq17[1,LENGTH(l_gdq.gdq17)-1]
    LET l_gdq.gdq18 = l_gdq.gdq18[1,LENGTH(l_gdq.gdq18)-1]

   #FUN-D20057 取得匯出檔名 --(s)
    CALL cl_xg_view_export_filename(l_gdr00) RETURNING l_gdq.gdq42
   #FUN-D20057 取得匯出檔名 --(e)

   #檢查跳頁 欄位合理性 --start
   #邏輯: 單頭單身模板僅允許1個跳頁欄位，若超過1個時，則4gl需改為複合欄位
   #例: 資料依 年+月 跳頁，則4gl建立TEMP TABLE時必須建立一個 "年+月"的欄位
    IF l_gdq.gdq14 = 'template2.aspx' THEN
       SELECT COUNT(*) INTO l_cnt FROM gds_file
        WHERE gds00 = l_gdr00
          AND gds03 = g_xgrid.skippage_field
       IF l_cnt = 0 THEN
          CALL cl_err(g_xgrid.skippage_field,'azz1282',1)
          CALL cl_xg_view_addlog(cl_getmsg('azz1282',g_lang)) #FUN-D20057
          RETURN
       END IF
    ELSE
      #FUN-D30045 ---(S)
       IF NOT cl_null(g_xgrid.skippage_field) THEN
         #FUN-D40059 add-----(S)
          #IF g_xgrid.skippage_field <> g_xgrid.grup_field THEN
          #   LET g_xgrid.skippage_field = g_xgrid.grup_field 
          #END IF
          IF NOT cl_null(g_xgrid.grup_field) THEN
             IF g_xgrid.skippage_field <> g_xgrid.grup_field THEN
                LET g_xgrid.skippage_field = g_xgrid.grup_field 
             END IF
          ELSE
             LET g_xgrid.grup_field = g_xgrid.skippage_field
          END IF
         #FUN-D40059 add-----(E)
       END IF
      #FUN-D30045 ---(E)
    END IF
   #檢查跳頁 欄位合理性 --end

   #檢查GROUP 欄位合理性 --start
    #FUN-D30056 ---(S)  調整抓取邏輯，優先順序 : 1.習慣設置(gdr16) 2.預設群組(gds36)
    #IF NOT cl_null(l_gdr16) THEN LET g_xgrid.grup_field = l_gdr16 END IF
    IF NOT cl_null(l_gdr16) THEN 
       LET g_xgrid.grup_field = l_gdr16
     ELSE
       IF cl_null(g_xgrid.grup_field) THEN
          CALL cl_xg_view_gds36(l_gdr00) RETURNING g_xgrid.grup_field #無習慣設定，改取gds36
       END IF
    END IF
    #FUN-D30056 ---(E)
    LET g_xgrid.grup_field = DOWNSHIFT(g_xgrid.grup_field)
    LET lst_token = base.StringTokenizer.create(g_xgrid.grup_field, ",")
    LET l_n = 1
    CALL l_flds.clear()
    WHILE lst_token.hasMoreTokens()
       LET l_flds[l_n] = lst_token.nextToken()
       FOR l_cnt = 1 TO l_flds.getlength()
           IF l_cnt = l_n THEN CONTINUE FOR END IF
           IF l_flds[l_n]=l_flds[l_cnt] THEN CONTINUE FOR END IF
       END FOR
       LET l_n = l_n + 1
    END WHILE
    FOR l_n = 1 TO l_flds.getlength()
        IF cl_null(l_flds[l_n]) THEN CONTINUE FOR END IF
        LET l_fld = l_flds[l_n]
        SELECT COUNT(*) INTO l_cnt FROM gds_file
         WHERE gds00 = l_gdr00
           AND gds03 = l_fld
           AND gds14 = 'Y'
        IF l_cnt > 0 THEN
           LET l_gdq.gdq04 = l_gdq.gdq04 CLIPPED,l_flds[l_n],","
        END IF
    END FOR
    IF NOT cl_null(l_gdq.gdq04) THEN
       LET l_gdq.gdq04 = l_gdq.gdq04[1,LENGTH(l_gdq.gdq04)-1]
    ELSE
       LET l_gdq.gdq04 = " "
    END IF


   #檢查GROUP 欄位合理性 --end
   #檢查ORDER 欄位合理性 --start
    IF NOT cl_null(l_gdr17) THEN LET g_xgrid.order_field = l_gdr17 END IF
    LET g_xgrid.order_field = DOWNSHIFT(g_xgrid.order_field)
    LET lst_token = base.StringTokenizer.create(g_xgrid.order_field, ",")
    LET l_n = 1
    CALL l_flds.clear()
    WHILE lst_token.hasMoreTokens()
       LET l_flds[l_n] = lst_token.nextToken()
       FOR l_cnt = 1 TO l_flds.getlength()
           IF l_cnt = l_n THEN CONTINUE FOR END IF
           IF l_flds[l_n]=l_flds[l_cnt] THEN CONTINUE FOR END IF
       END FOR
       LET l_n = l_n + 1
    END WHILE
    FOR l_n = 1 TO l_flds.getlength()
        IF cl_null(l_flds[l_n]) THEN CONTINUE FOR END IF
        LET l_fld = l_flds[l_n]
        LET l_fldstr = l_fld 
        IF l_fldstr.getIndexOf(" desc",1) > 0 THEN
           LET l_fld = cl_replace_str(l_fld," desc","")
           LET l_fldstr = " DESC"
        ELSE
           LET l_fldstr = NULL
        END IF
        SELECT COUNT(*) INTO l_cnt FROM gds_file
         WHERE gds00 = l_gdr00
           AND gds03 = l_fld
           AND gds14 = 'Y'
           AND gds12 = '2'
        IF l_cnt > 0 THEN
           #LET l_gdq.gdq05 = l_gdq.gdq05 CLIPPED,l_flds[l_n],","
           LET l_gdq.gdq05 = l_gdq.gdq05 CLIPPED,l_fld, l_fldstr CLIPPED,","
        END IF
    END FOR
    IF NOT cl_null(l_gdq.gdq05) THEN
       LET l_gdq.gdq05 = l_gdq.gdq05[1,LENGTH(l_gdq.gdq05)-1]
    ELSE
       LET l_gdq.gdq05 = " "
    END IF
   #檢查ORDER 欄位合理性 --end
    
    SELECT zz011 INTO g_zz011 FROM zz_file
     WHERE zz01 = g_prog
    LET lc_sys_a = g_zz011    #modify lc_sys by guanyao160524
    LET lc_sys_a = UPSHIFT(lc_sys_a) CLIPPED #modify lc_sys by guanyao160524
    IF lc_sys_a.subString(1,1) = 'C' THEN
       LET lc_sys_a = 'A',lc_sys_a.subString(2,lc_sys_a.getLength())
    END IF
    CALL cl_xg_view_gdq21(l_gdq.gdq02) RETURNING l_gdq.gdq21
   #SELECT * INTO l_gdr.* FROM gdr_file WHERE gdr00 = l_gdr00
   #LET l_gdq.gdq01 = g_prog,YEAR(g_today) USING '<<<<',MONTH(g_today) USING '<<',DAY(g_today) USING '<<',
   #                  l_time[1,2],l_time[4,5],l_time[7,8]
   #LET l_gdq.gdq02 = l_gdr00

    IF cl_null(g_xgrid.title1) THEN
       SELECT zo02 INTO l_gdq.gdq06 FROM zo_file WHERE zo01 = g_lang
    ELSE
       LET l_gdq.gdq06 = g_xgrid.title1
    END IF

    IF cl_null(g_xgrid.title2) THEN
      #FUN-D40059 ----start
       #SELECT gaz03 INTO l_gdq.gdq07 FROM gaz_file
       # WHERE gaz01 = g_prog
       #   AND gaz02=g_lang
       LET l_gaz03 = NULL
       LET l_gaz06 = NULL
       SELECT gaz03,gaz06 INTO l_gaz03,l_gaz06
         FROM gaz_file
        WHERE gaz01 = g_prog
          AND gaz02 =g_lang
       IF NOT cl_null(l_gaz06) THEN
          LET l_gdq.gdq07 = l_gaz06
       ELSE
          LET l_gdq.gdq07 = l_gaz03
       END IF
      #FUN-D40059 ----end
    ELSE
       LET l_gdq.gdq07 = g_xgrid.title2
    END IF
    LET l_gen02 = NULL
    SELECT zx02 INTO l_gen02 FROM zx_file WHERE zx01 = g_user
    IF cl_null(l_gen02) THEN
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_user
    END IF
    IF cl_null(l_gen02) THEN
       LET l_gdq.gdq08 = g_user
    ELSE
       LET l_gdq.gdq08 = l_gen02
    END IF
    LET l_gdq.gdq09 = g_today
    LET l_gdq.gdq10 = g_xgrid.skippage_field

    IF NOT cl_null(g_xgrid.condition) THEN
       LET l_gdq.gdq11 = g_xgrid.condition
    END IF

   #取得營運中心圖檔
    LET l_logourl = FGL_GETENV("FGLASIP") || "/tiptop/pic/pdf_logo_",g_dbs CLIPPED,g_rlang CLIPPED,".jpg"
   #FUN-D40059 ---start
    IF l_logourl.getIndexOf("http:",1) <> 1 THEN
       LET l_logourl = "http://",l_logourl
    END IF  
   #FUN-D40059 ---end
    LET l_logopath = FGL_GETENV("TOP")||"/doc/pic/pdf_logo_",g_dbs CLIPPED,g_rlang CLIPPED,".jpg"
    IF NOT os.Path.exists(l_logopath) THEN
       CALL cl_err('','azz1281',1)
       CALL cl_xg_view_addlog(cl_getmsg('azz1281',g_lang)) #FUN-D20057
       LET l_logopath = FGL_GETENV("TOP")||"/doc/pic/space_0.gif"
       LET l_logourl = FGL_GETENV("FGLASIP") || "/tiptop/pic/space_0.gif"
    END IF

    LET l_gdq.gdq12 = l_logourl
   #LET l_gdq.gdq13 = g_xgrid.grup_sum_field  #FUN-D30056 marked
    IF cl_null(l_gdq.gdq15) THEN LET l_gdq.gdq15 = 'A' END IF
    LET l_gdq.gdq16 = l_gdq16
    LET l_gdq.gdq01 = l_certid
    LET l_gdq.gdq19 = TIME
    #LET l_gdq.gdq20 = g_clas
    LET l_gdq.gdq20 = g_user #FUN-D40059
    LET l_gdq.gdq22 = g_xgrid.headerinfo1
    LET l_gdq.gdq23 = g_xgrid.headerinfo2
    LET l_gdq.gdq24 = g_xgrid.headerinfo3
    LET l_gdq.gdq25 = g_xgrid.headerinfo4
    LET l_gdq.gdq26 = g_xgrid.headerinfo5
    CALL cl_xg_fix_info(g_xgrid.footerinfo1,g_xgrid.footerinfo2,g_xgrid.footerinfo3,g_xgrid.footerinfo4,g_xgrid.footerinfo5)
       RETURNING g_xgrid.footerinfo1,g_xgrid.footerinfo2,g_xgrid.footerinfo3,g_xgrid.footerinfo4,g_xgrid.footerinfo5
    LET l_gdq.gdq27 = g_xgrid.footerinfo1
    LET l_gdq.gdq28 = g_xgrid.footerinfo2
    LET l_gdq.gdq29 = g_xgrid.footerinfo3
    LET l_gdq.gdq30 = g_xgrid.footerinfo4
    LET l_gdq.gdq31 = g_xgrid.footerinfo5
   #子報表 ---(S)
    IF l_gdr06 MATCHES '[34]' THEN
       #取得各頁籤標題
        DECLARE gds18_cur CURSOR FOR
         SELECT UNIQUE gds18 FROM gds_file
          WHERE gds00 = l_gdr00
            AND gds18 > 1
          ORDER BY gds18
        FOREACH gds18_cur INTO l_gds18
            DECLARE gds19_cur CURSOR FOR
             SELECT gds19 FROM gds_file
              WHERE gds00 = l_gdr00
                AND gds18 = l_gds18
            FOREACH gds19_cur INTO l_gds19
                IF cl_null(l_gds19) THEN CONTINUE FOREACH END IF
                EXIT FOREACH
            END FOREACH
            LET l_gdq.gdq34 = l_gdq.gdq34 CLIPPED,l_gds19,'|'
        END FOREACH
        IF LENGTH(l_gdq.gdq34) > 1 THEN
           LET l_gdq.gdq34 = l_gdq.gdq34[1,LENGTH(l_gdq.gdq34)-1]
        END IF
         
       #取得各子報表關聯KEY   
        FOREACH gds18_cur INTO l_gds18
            LET l_gds28 = NULL
            LET l_gds03 = NULL
            SELECT gds28,gds03 INTO l_gds28,l_gds03
              FROM gds_file
             WHERE gds00 = l_gdr00
               AND gds18 = l_gds18
               AND gds28 IS NOT NULL
            LET l_gdq.gdq35 = l_gdq.gdq35 CLIPPED,l_gds03,",",l_gds28,"|"
        END FOREACH
        LET l_gdq.gdq35 = l_gdq.gdq35[1,LENGTH(l_gdq.gdq35)-1]
    END IF
   #子報表 ---(E)

   #FUN-D20057 取得匯出權限 --(s)
    CALL cl_xg_view_export_permission() RETURNING l_gdq.gdq43
   #FUN-D20057 取得匯出權限 --(e)
   #FUN-CC0115 自動匯出郵寄 --(s)
    LET l_gdq.gdq45 = 'N'
    CALL cl_xg_view_maillist(l_gdq.*) RETURNING l_gdq.*
   #FUN-CC0115 自動匯出郵寄 --(e)
    
    LET l_gdq.gdq32 = g_xgrid.dynamic_title #動態標題
    IF cl_null(l_gdq.gdq13) THEN LET l_gdq.gdq13=NULL END IF
    INSERT INTO gdq_file VALUES(l_gdq.*)
    IF STATUS THEN
       CALL cl_err('ins gdq:',STATUS,1)
       CALL cl_xg_view_addlog("INSERT INTO gdq_file ERROR:"||STATUS) #FUN-D20057
       RETURN
    END IF

    DISPLAY "url:",l_url
    IF g_bgjob = 'Y' THEN
       CALL cl_xg_view_bgjob(l_url) #背景作業
    ELSE
       CALL ui.Interface.frontCall("standard","launchurl",l_url ,res)
    END IF
    CALL cl_xg_view_logfile()
    INITIALIZE g_xgrid.* TO NULL


END FUNCTION

FUNCTION cl_get_order_field(p_nums,p_fields)
DEFINE p_nums    LIKE type_file.chr10
DEFINE p_fields  LIKE type_file.chr1000
DEFINE lst_token base.StringTokenizer
DEFINE ls_token  STRING
DEFINE l_flds    DYNAMIC ARRAY OF STRING   
DEFINE l_cnt,i,j LIKE type_file.num5
DEFINE l_str     LIKE type_file.chr1000

   IF cl_null(p_nums) THEN RETURN ' ' END IF
   IF cl_null(p_fields) THEN RETURN ' ' END IF
   
   LET lst_token = base.StringTokenizer.create(p_fields, ",")
   LET l_cnt = 1
   WHILE lst_token.hasMoreTokens()
      LET l_flds[l_cnt] = lst_token.nextToken()
      LET l_cnt = l_cnt + 1
   END WHILE

   LET l_str = NULL
   FOR i = 1 TO LENGTH(p_nums)
       IF cl_null(p_nums[i,i]) THEN CONTINUE FOR END IF
       #LET j = p_nums[i,i]
       LET j = cl_xg_get_pnum(p_nums[i,i])
       LET l_str = l_str CLIPPED,l_flds[j],","
   END FOR
   IF LENGTH(l_str)>1 THEN
      LET l_str = l_str[1,LENGTH(l_str)-1]
   END IF

   RETURN l_str

END FUNCTION

# Descriptions...: 取得"不要"顯示群組加總的欄位
# Date & Author..: 2012/11/30 by odyliao
# Input Parameter: p_nums   : 參考順序 (對應p_fields的參考)
#                  p_check  : 稽核欄位 (格式: YNN)
#                  p_fields : 欄位代號 (對應p_nums)
# Return Code....: l_str
# Memo...........: No.FUN-CB0101
# Example........: LET g_xgrid.grup_sum_field = cl_get_sum_field('124','YNY','ima01,ima02,ima021,ima06')
#                  則 g_xgrid.grup_sum_field 會得到 ima02
FUNCTION cl_get_sum_field(p_nums,p_check,p_fields)
DEFINE p_nums    LIKE type_file.chr10
DEFINE p_check   LIKE type_file.chr10
DEFINE p_fields  LIKE type_file.chr1000
DEFINE lst_token base.StringTokenizer
DEFINE ls_token  STRING
DEFINE l_flds    DYNAMIC ARRAY OF STRING   
DEFINE l_cnt,i,j LIKE type_file.num5
DEFINE l_str     LIKE type_file.chr1000
DEFINE l_flag    LIKE type_file.chr1

   IF cl_null(p_nums) THEN RETURN ' ' END IF
   IF cl_null(p_fields) THEN RETURN ' ' END IF
   LET l_flag = 'N'
   FOR i = 1 TO LENGTH(p_check) 
       IF p_check[i,i] = 'N' THEN LET l_flag = 'Y' EXIT FOR END IF
   END FOR
   IF l_flag = 'N' THEN RETURN ' ' END IF
   
   LET lst_token = base.StringTokenizer.create(p_fields, ",")
   LET l_cnt = 1
   WHILE lst_token.hasMoreTokens()
      LET l_flds[l_cnt] = lst_token.nextToken()
      LET l_cnt = l_cnt + 1
   END WHILE

   LET l_str = NULL
   FOR i = 1 TO LENGTH(p_nums)
       IF p_check[i,i]= 'Y' THEN CONTINUE FOR END IF
       IF cl_null(p_nums[i,i]) THEN CONTINUE FOR END IF
       IF p_check[i,i] = 'N' THEN
          #LET j = p_nums[i,i]
          LET j = cl_xg_get_pnum(p_nums[i,i])
          LET l_str = l_str CLIPPED,l_flds[j],","
       END IF
   END FOR
   IF LENGTH(l_str)>1 THEN
      LET l_str = l_str[1,LENGTH(l_str)-1]
   END IF

   RETURN l_str

END FUNCTION


# Descriptions...: 取得跳頁欄位
# Date & Author..: 2012/11/30 by odyliao
# Input Parameter: p_nums   : 參考順序 (對應p_fields的參考)
#                  p_check  : 稽核欄位 (格式: YNN)
#                  p_fields : 欄位代號 (對應p_nums)
# Return Code....: l_str
# Memo...........: No.FUN-CB0101
# Example........: LET g_xgrid.skip_field = cl_get_skip_field('124','YNY','ima01,ima02,ima021,ima06')
#                  則 g_xgrid.skip_field 會得到 ima01,ima06
FUNCTION cl_get_skip_field(p_nums,p_check,p_fields)
DEFINE p_nums    LIKE type_file.chr10
DEFINE p_check   LIKE type_file.chr10
DEFINE p_fields  LIKE type_file.chr1000
DEFINE lst_token base.StringTokenizer
DEFINE ls_token  STRING
DEFINE l_flds    DYNAMIC ARRAY OF STRING
DEFINE l_cnt,i,j LIKE type_file.num5
DEFINE l_str     LIKE type_file.chr1000
DEFINE l_flag    LIKE type_file.chr1

   IF cl_null(p_nums) THEN RETURN ' ' END IF
   IF cl_null(p_fields) THEN RETURN ' ' END IF
   LET l_flag = 'N'
   FOR i = 1 TO LENGTH(p_check)
       IF p_check[i,i] = 'Y' THEN LET l_flag = 'Y' EXIT FOR END IF
   END FOR
   IF l_flag = 'N' THEN RETURN ' ' END IF

   LET lst_token = base.StringTokenizer.create(p_fields, ",")
   LET l_cnt = 1
   WHILE lst_token.hasMoreTokens()
      LET l_flds[l_cnt] = lst_token.nextToken()
      LET l_cnt = l_cnt + 1
   END WHILE
   
   LET l_str = NULL
   FOR i = 1 TO LENGTH(p_nums)
       IF p_check[i,i]= 'N' THEN CONTINUE FOR END IF
       IF cl_null(p_nums[i,i]) THEN CONTINUE FOR END IF
       IF p_check[i,i] = 'Y' THEN
          #LET j = p_nums[i,i]
          LET j = cl_xg_get_pnum(p_nums[i,i])
          LET l_str = l_str CLIPPED,l_flds[j],","
       END IF
   END FOR
   IF LENGTH(l_str)>1 THEN
      LET l_str = l_str[1,LENGTH(l_str)-1]
   END IF

   RETURN l_str

END FUNCTION

##################################################
# Private Func...: TRUE
# Descriptions...: 設定XtraGrid的URL字串
# Input Parameter:
# Return code....: l_certid,l_url,l_url_param
##################################################
FUNCTION cl_set_xg_url()
   DEFINE  l_rep_db,l_instance,l_server    STRING
   DEFINE  l_rep_db_pw,l_str               STRING
   DEFINE  l_rep_db_user,l_sqlserver_ip    STRING
   DEFINE  l_certid,l_url,l_db_type        STRING
   DEFINE  lc_azz06                        LIKE type_file.chr1 #azz_file.azz06,
   DEFINE  lc_zz06                         LIKE type_file.chr1 #zz_file.zz06,
   DEFINE  li_rptlimit                     LIKE type_file.num10
   DEFINE  crip,ms_codeset                 STRING      ## CR Server IP ##
   DEFINE  certid                          LIKE type_file.num5
   DEFINE  l_plant                         STRING
   DEFINE  lc_aza49                        LIKE type_file.chr1
   DEFINE  l_azp20                         LIKE azp_file.azp20
   DEFINE  l_url_param                     STRING        #存在zax42的網址參數
   DEFINE  l_time                          STRING
   DEFINE  l_sb                            base.StringBuffer

   LET l_rep_db = g_dbs CLIPPED
   LET l_rep_db_pw = ""
   LET l_instance = ""
   LET l_db_type=cl_db_get_database_type()

   SELECT azz06 INTO lc_azz06 FROM azz_file
   CASE
   WHEN l_db_type="ORA"
      IF lc_azz06='Y' Then
         CALL cl_tipp_cbdco(l_rep_db CLIPPED) RETURNING l_rep_db_user,l_rep_db_pw
      ELSE
         LET l_str = "dbi.database.", g_report CLIPPED, ".password"
         LET l_rep_db_pw = fgl_getresource(l_str) CLIPPED
      END IF
      LET l_instance = fgl_getenv('ORACLE_SID') CLIPPED

      CALL cl_prt_trans_ascii(l_rep_db_user.trim()) RETURNING l_str  ## DB ##
      LET l_rep_db_user = l_str.trim()
      LET l_str = ""
      CALL cl_prt_trans_ascii(l_rep_db_pw.trim()) RETURNING l_str ## DB_PW ##
      LET l_rep_db_pw = l_str.trim()
      LET l_str = ""
      CALL cl_prt_trans_ascii(l_instance.trim()) RETURNING l_str  ## INSTANCE ##
      LET l_instance = l_str.trim()

     #LET g_asp_param.t = l_rep_db
     #LET g_asp_param.t1 = l_rep_db_pw
      LET l_sqlserver_ip = cl_xg_get_serverip()
      #LET l_sqlserver_ip = '10.40.40.30'
      CALL cl_prt_trans_ascii(l_sqlserver_ip.trim()) RETURNING l_str
      LET l_sqlserver_ip = l_str.trim()
      LET l_url_param = "user=",l_rep_db_user,"&pswd=",l_rep_db_pw,"&sid=",l_instance,"&ip=",l_sqlserver_ip

   END CASE
   
   CALL cl_get_plant() RETURNING l_plant

   LET l_time = CURRENT YEAR TO FRACTION(3)  #時間截記
   LET l_sb = base.StringBuffer.create()
   CALL l_sb.append(l_time)
   CALL l_sb.replace(":","",0)
   CALL l_sb.replace(" ","",0)
   CALL l_sb.replace("-","",0)
   CALL l_sb.replace(".","",0)
   LET l_time = l_sb.toString()

   LET crip = fgl_getenv("XTRAGRIDIP")   # CR Server IP
   LET certid = FGL_GETPID()
   LET l_certid = certid CLIPPED,l_time
  #DISPLAY "certid=",l_certid
   LET l_certid = l_certid.trim()
   LET l_url = crip CLIPPED,"Default.aspx"

   LET l_url = l_url CLIPPED,"?report_sn=",l_certid CLIPPED

   RETURN l_certid,l_url,l_url_param
END FUNCTION

FUNCTION cl_xg_view_gdq21(p_gdr00)
DEFINE p_gdr00  LIKE type_file.chr100
DEFINE l_sql    STRING
DEFINE l_gdq21  STRING
DEFINE l_gds03  LIKE gds_file.gds03
DEFINE l_gds14  LIKE gds_file.gds14
DEFINE l_flag   LIKE type_file.chr1

   CALL cl_replace_str(p_gdr00,"|",",") RETURNING p_gdr00
   LET l_sql = "SELECT gds03,gds14 FROM gds_file ",
               " WHERE gds00 IN (",p_gdr00,")",
               "   AND gds14 IN ('M','P','V','X')"
  #DISPLAY l_sql
   PREPARE xgview_gdq21_pr FROM l_sql
   DECLARE xgview_gdq21_cs CURSOR FOR xgview_gdq21_pr
   LET l_gdq21 = ''
   FOREACH xgview_gdq21_cs INTO l_gds03,l_gds14
       IF l_gds14 NOT MATCHES '[MPVX]' THEN CONTINUE FOREACH END IF
       
       CASE l_gds14
         WHEN "M"   #依多單位設定(asms290)
           SELECT sma115 INTO l_flag FROM sma_file WHERE sma00='0'
         WHEN "V"   #依計價單位設定(asms290)
           SELECT sma116 INTO l_flag FROM sma_file WHERE sma00='0'
           CASE l_flag
             WHEN '0'
                 LET l_flag = "N"
             WHEN '1'
                 IF lc_sys_a = 'APM' THEN
                     LET l_flag = "Y"
                 ELSE
                     LET l_flag = "N"
                 END IF
             WHEN '2'
                 IF lc_sys_a = 'AXM' OR lc_sys_a = 'ATM' THEN
                     LET l_flag = "Y"
                 ELSE
                     LET l_flag = "N"
                 END IF
             WHEN '3'
             LET l_flag = "Y"
           END CASE
         WHEN "X"      #依多套帳設定(aoos010)
              SELECT aza63 INTO l_flag FROM aza_file WHERE aza01='0'
         WHEN "P"      #依利潤中心設定(agls103)  
              SELECT aaz90 INTO l_flag FROM aaz_file WHERE aaz00='0'
       END CASE

       LET l_gdq21 = l_gdq21 CLIPPED,l_gds03,",",l_flag,"|"

   END FOREACH

   IF l_gdq21.getLength() > 0 THEN
      LET l_gdq21 = l_gdq21.subString(1,l_gdq21.getLength()-1)
   END IF

   IF NOT cl_null(g_xgrid.visible_column) THEN
      LET l_gdq21 = l_gdq21,"|",g_xgrid.visible_column
   END IF

   RETURN l_gdq21

END FUNCTION

#檢查使用 CR or XtraGrid
FUNCTION cl_chk_kind_of_report(p_table)
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_n1,l_n2   LIKE type_file.num5
DEFINE p_table     LIKE type_file.chr100
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_msg       STRING

    LET g_rep_choice = 0
    #檢查TABLE有沒有資料
    IF NOT cl_null(p_table) THEN
       LET l_cnt = cl_gre_rowcnt(p_table)
       IF l_cnt = 0 THEN RETURN END IF
    END IF
    #檢查是否存在 p_zaw (CR)
     SELECT COUNT(*) INTO l_n1
       FROM zaw_file
      WHERE zaw01 = g_prog
     IF STATUS = -206 THEN
        LET l_n1 = 0 
     END IF
    #檢查是否存在 p_xglang (XtraGrid)
     SELECT COUNT(*) INTO l_n2
       FROM gdr_file
      WHERE gdr01 = g_prog
     IF STATUS = -206 THEN
        LET l_n2 = 0 
     END IF
      
     IF (l_n1 > 0) AND (l_n2 > 0) THEN
       #都存在，開窗詢問要開啟 CR or XtraGrid
       LET l_msg = cl_getmsg('azz1265',g_lang)
       PROMPT l_msg CLIPPED FOR g_rep_choice
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()

                  ON ACTION about
                     CALL cl_about()

                  ON ACTION help
                     CALL cl_show_help()

                  ON ACTION controlg 
                     CALL cl_cmdask()

       END PROMPT
     ELSE
       IF l_n1 > 0 THEN LET g_rep_choice = 1 END IF
       IF l_n2 > 0 THEN LET g_rep_choice = 2 END IF
     END IF
      

END FUNCTION

FUNCTION cl_xg_get_serverip()
DEFINE l_ip  LIKE type_file.chr100
DEFINE l_n1,l_n2  LIKE type_file.num5
DEFINE l_str  STRING

    LET l_str = FGL_GETENV("FGLASIP")
    LET l_n1 = l_str.getIndexOf("http://",1)
    LET l_n2 = l_str.getIndexOf("/",l_n2+8)
    LET l_ip = l_str
    LET l_ip = l_ip[l_n1+7,l_n2-1]
    RETURN l_ip
    

END FUNCTION


#報表尾資訊整理與對齊
FUNCTION cl_xg_fix_info(p_info1,p_info2,p_info3,p_info4,p_info5)
DEFINE p_info1  LIKE type_file.chr1000
DEFINE p_info2  LIKE type_file.chr1000
DEFINE p_info3  LIKE type_file.chr1000
DEFINE p_info4  LIKE type_file.chr1000
DEFINE p_info5  LIKE type_file.chr1000
DEFINE l_str   STRING
DEFINE l_i,l_n,i  LIKE type_file.num5
DEFINE l_fld   LIKE type_file.chr1000
DEFINE l_len   LIKE type_file.num5
DEFINE l_len1  LIKE type_file.num5
DEFINE l_len2  LIKE type_file.num5
DEFINE l_len3  LIKE type_file.num5
DEFINE l_len4  LIKE type_file.num5
DEFINE l_len5  LIKE type_file.num5
DEFINE lst_token base.StringTokenizer
DEFINE ls_token  STRING
DEFINE l_flag1 LIKE type_file.chr1
DEFINE l_flag2 LIKE type_file.chr1
DEFINE l_flag3 LIKE type_file.chr1
DEFINE l_flag4 LIKE type_file.chr1
DEFINE l_flag5 LIKE type_file.chr1
DEFINE l_flds  DYNAMIC ARRAY OF RECORD
                                 section1 LIKE type_file.chr1000,
                                 section2 LIKE type_file.chr1000,
                                 section3 LIKE type_file.chr1000,
                                 section4 LIKE type_file.chr1000,
                                 section5 LIKE type_file.chr1000
                                END RECORD
   
    LET l_flag1 = 'N'
    LET l_flag2 = 'N'
    LET l_flag3 = 'N'
    LET l_flag4 = 'N'
    LET l_flag5 = 'N'
   #拆解 footerinfo1 
    IF NOT cl_null(p_info1) THEN
       LET lst_token = base.StringTokenizer.create(p_info1, "|")
       LET l_n = 1
       WHILE lst_token.hasMoreTokens()
          LET l_fld = lst_token.nextToken()
          CASE l_n
            WHEN 1 LET l_flds[1].section1 = l_fld
            WHEN 2 LET l_flds[1].section2 = l_fld
            WHEN 3 LET l_flds[1].section3 = l_fld
            WHEN 4 LET l_flds[1].section4 = l_fld
            WHEN 5 LET l_flds[1].section5 = l_fld
          END CASE
          LET l_flag1 = 'Y'
          LET l_n = l_n + 1
          IF l_n > 5 THEN EXIT WHILE END IF
       END WHILE
   END IF
   
   #拆解 footerinfo2 
    IF NOT cl_null(p_info2) THEN
       LET lst_token = base.StringTokenizer.create(p_info2, "|")
       LET l_n = 1
       WHILE lst_token.hasMoreTokens()
          LET l_fld = lst_token.nextToken()
          CASE l_n
            WHEN 1 LET l_flds[2].section1 = l_fld
            WHEN 2 LET l_flds[2].section2 = l_fld
            WHEN 3 LET l_flds[2].section3 = l_fld
            WHEN 4 LET l_flds[2].section4 = l_fld
            WHEN 5 LET l_flds[2].section5 = l_fld
          END CASE
          LET l_n = l_n + 1
          LET l_flag2 = 'Y'
          IF l_n > 5 THEN EXIT WHILE END IF
       END WHILE
   END IF

   #拆解 footerinfo3
    IF NOT cl_null(p_info3) THEN
       LET lst_token = base.StringTokenizer.create(p_info3, "|")
       LET l_n = 1
       WHILE lst_token.hasMoreTokens()
          LET l_fld = lst_token.nextToken()
          CASE l_n
            WHEN 1 LET l_flds[3].section1 = l_fld
            WHEN 2 LET l_flds[3].section2 = l_fld
            WHEN 3 LET l_flds[3].section3 = l_fld
            WHEN 4 LET l_flds[3].section4 = l_fld
            WHEN 5 LET l_flds[3].section5 = l_fld
          END CASE
          LET l_n = l_n + 1
          LET l_flag3 = 'Y'
          IF l_n > 5 THEN EXIT WHILE END IF
       END WHILE
   END IF

   #拆解 footerinfo4
    IF NOT cl_null(p_info4) THEN
       LET lst_token = base.StringTokenizer.create(p_info4, "|")
       LET l_n = 1
       WHILE lst_token.hasMoreTokens()
          LET l_fld = lst_token.nextToken()
          CASE l_n
            WHEN 1 LET l_flds[4].section1 = l_fld
            WHEN 2 LET l_flds[4].section2 = l_fld
            WHEN 3 LET l_flds[4].section3 = l_fld
            WHEN 4 LET l_flds[4].section4 = l_fld
            WHEN 5 LET l_flds[4].section5 = l_fld
          END CASE
          LET l_n = l_n + 1
          LET l_flag4 = 'Y'
          IF l_n > 5 THEN EXIT WHILE END IF
       END WHILE
   END IF

   #拆解 footerinfo5
    IF NOT cl_null(p_info5) THEN
       LET lst_token = base.StringTokenizer.create(p_info5, "|")
       LET l_n = 1
       WHILE lst_token.hasMoreTokens()
          LET l_fld = lst_token.nextToken()
          CASE l_n
            WHEN 1 LET l_flds[5].section1 = l_fld
            WHEN 2 LET l_flds[5].section2 = l_fld
            WHEN 3 LET l_flds[5].section3 = l_fld
            WHEN 4 LET l_flds[5].section4 = l_fld
            WHEN 5 LET l_flds[5].section5 = l_fld
          END CASE
          LET l_n = l_n + 1
          LET l_flag5 = 'Y'
          IF l_n > 5 THEN EXIT WHILE END IF
       END WHILE
   END IF

   LET l_len1= 0 
   LET l_len2= 0 
   LET l_len3= 0 
   LET l_len4= 0 
   LET l_len5= 0 
  #找出每個Section最寬的
   FOR i = 1 TO 5
       LET l_len = FGL_WIDTH(l_flds[i].section1)
       IF (l_len1 = 0) OR (l_len > l_len1) THEN LET l_len1=l_len END IF
       LET l_len = FGL_WIDTH(l_flds[i].section2)
       IF (l_len2 = 0) OR (l_len > l_len2) THEN LET l_len2=l_len END IF
       LET l_len = FGL_WIDTH(l_flds[i].section3)
       IF (l_len3 = 0) OR (l_len > l_len3) THEN LET l_len3=l_len END IF
       LET l_len = FGL_WIDTH(l_flds[i].section4)
       IF (l_len4 = 0) OR (l_len > l_len4) THEN LET l_len4=l_len END IF
       LET l_len = FGL_WIDTH(l_flds[i].section5)
       IF (l_len5 = 0) OR (l_len > l_len5) THEN LET l_len5=l_len END IF
   END FOR
  #填空
   FOR i = 1 TO 5
       LET l_len = FGL_WIDTH(l_flds[i].section1)
       IF l_len1 > l_len AND l_len > 0 THEN
          FOR l_i = 1 TO l_len1-l_len
              LET l_flds[i].section1=l_flds[i].section1,' '
          END FOR
       END IF
       LET l_len = FGL_WIDTH(l_flds[i].section2)
       IF l_len2 > l_len AND l_len > 0 THEN
          FOR l_i = 1 TO l_len2-l_len
              LET l_flds[i].section2=l_flds[i].section2,' '
          END FOR
       END IF
       LET l_len = FGL_WIDTH(l_flds[i].section3)
       IF l_len3 > l_len AND l_len > 0 THEN
          FOR l_i = 1 TO l_len3-l_len
              LET l_flds[i].section3=l_flds[i].section3,' '
          END FOR
       END IF
       LET l_len = FGL_WIDTH(l_flds[i].section4)
       IF l_len4 > l_len AND l_len > 0 THEN
          FOR l_i = 1 TO l_len4-l_len
              LET l_flds[i].section4=l_flds[i].section4,' '
          END FOR
       END IF
       LET l_len = FGL_WIDTH(l_flds[i].section5)
       IF l_len5 > l_len AND l_len > 0 THEN
          FOR l_i = 1 TO l_len5-l_len
              LET l_flds[i].section5=l_flds[i].section5,' '
          END FOR
       END IF
       LET l_flds[i].section1 = cl_replace_str(l_flds[i].section1,"  ","　")
       LET l_flds[i].section2 = cl_replace_str(l_flds[i].section2,"  ","　")
       LET l_flds[i].section3 = cl_replace_str(l_flds[i].section3,"  ","　")
       LET l_flds[i].section4 = cl_replace_str(l_flds[i].section4,"  ","　")
       LET l_flds[i].section5 = cl_replace_str(l_flds[i].section5,"  ","　")
   END FOR
  
   IF l_flag1 = 'Y' THEN
      LET p_info1 = l_flds[1].section1,'　　　',l_flds[1].section2,'　　　',l_flds[1].section3,'　　　',l_flds[1].section4,'　　　',l_flds[1].section5
   END IF
   IF l_flag2 = 'Y' THEN
      LET p_info2 = l_flds[2].section1,'　　　',l_flds[2].section2,'　　　',l_flds[2].section3,'　　　',l_flds[2].section4,'　　　',l_flds[2].section5
   END IF
   IF l_flag3 = 'Y' THEN
      LET p_info3 = l_flds[3].section1,'　　　',l_flds[3].section2,'　　　',l_flds[3].section3,'　　　',l_flds[3].section4,'　　　',l_flds[3].section5
   END IF
   IF l_flag4 = 'Y' THEN
      LET p_info4 = l_flds[4].section1,'　　　',l_flds[4].section2,'　　　',l_flds[4].section3,'　　　',l_flds[4].section4,'　　　',l_flds[4].section5
   END IF
   IF l_flag5 = 'Y' THEN
      LET p_info5 = l_flds[5].section1,'　　　',l_flds[5].section2,'　　　',l_flds[5].section3,'　　　',l_flds[5].section4,'　　　',l_flds[5].section5
   END IF

   RETURN p_info1,p_info2,p_info3,p_info4,p_info5


END FUNCTION

#檢查 SQL 筆數
FUNCTION cl_xg_rowcnt(p_table,p_where)
DEFINE p_table  LIKE type_file.chr1000
DEFINE p_where  LIKE type_file.chr1000
DEFINE l_sql    STRING
DEFINE l_cnt    LIKE type_file.num10

    LET l_cnt = 0
    IF cl_null(p_where) THEN LET p_where = ' 1=1' END IF
    LET l_sql = "SELECT COUNT(*) FROM ",p_table," WHERE ",p_where
    PREPARE cl_xg_rowcnt_pr FROM l_sql
    EXECUTE cl_xg_rowcnt_pr INTO l_cnt

    IF l_cnt <= 0 THEN
       CALL cl_err('!','lib-216',1)
    END IF

    RETURN l_cnt


END FUNCTION

# Descriptions...: 組合動態標題
# Date & Author..: 2012/11/22 by odyliao
# Input Parameter: p_str : 原字串(當報表有多個動態標題時，此字串累加，並用 | 符號隔開)
#                  p_column : 欄位代號
#                  p_desc : 動態標題說明
# Return Code....: p_str
# Memo...........: No.FUN-CB0101
#                  動態標題格式為 (p_column),(p_desc)，若多個時用|隔開，例: col01,標題一|col2,標題二|col3,標題三
FUNCTION cl_xg_dynamic_title(p_str,p_column,p_desc,p_num)
DEFINE p_str     STRING
DEFINE p_num,l_n LIKE type_file.num5
DEFINE p_column  LIKE type_file.chr100
DEFINE p_desc    LIKE type_file.chr300
DEFINE l_descs   DYNAMIC ARRAY OF STRING
DEFINE lst_token base.StringTokenizer
DEFINE ls_token  STRING

    LET p_desc = cl_replace_str(p_desc,".","")
    LET p_desc = cl_replace_str(p_desc,":","")
    LET p_desc = cl_replace_str(p_desc,",","")
    IF cl_null(p_num) OR p_num=0 THEN  #適用於 ze 只維護一筆時的情形
       IF cl_null(p_str) THEN
          LET p_str = p_column CLIPPED,',',p_desc CLIPPED
       ELSE
          LET p_str = p_str CLIPPED,'|',p_column CLIPPED,',',p_desc CLIPPED
       END IF
    ELSE                               #適用於多筆標題維護在同一筆ze時(例如 gre-227 : 預算項目|部門編號|異動碼別)
       LET lst_token = base.StringTokenizer.create(p_desc, "|")
       LET l_n = 1
       WHILE lst_token.hasMoreTokens()
          LET l_descs[l_n] = lst_token.nextToken()
          LET l_n = l_n + 1
       END WHILE
       CALL l_descs.deleteElement(l_n)
       LET l_n = l_n - 1
       IF p_num <= l_n THEN
          IF cl_null(p_str) THEN
             LET p_str = p_column CLIPPED,',',l_descs[p_num] CLIPPED
          ELSE
             LET p_str = p_str CLIPPED,'|',p_column CLIPPED,',',l_descs[p_num] CLIPPED
          END IF
       END IF
    END IF
  
    RETURN p_str

END FUNCTION


FUNCTION cl_xg_chk_column(p_gdr00,p_sql,p_table,p_where)
DEFINE p_gdr00  LIKE gdr_file.gdr00
DEFINE l_sql    STRING
DEFINE l_cnt    LIKE type_file.num10
DEFINE p_sql    STRING
DEFINE p_table  LIKE type_file.chr1000
DEFINE p_where  STRING
DEFINE l_gds01  LIKE gds_file.gds01
DEFINE l_gds03  LIKE gds_file.gds03
DEFINE l_gds04  LIKE gds_file.gds04

    WHENEVER ERROR CONTINUE
    
    LET l_sql = "SELECT gds01,gds03,gds04 FROM gds_file ",  
                " WHERE gds00 = ",p_gdr00,
                "   AND gds18 = 1 ",
                " ORDER BY gds01 "
    PREPARE cl_xg_chk_column_gds_pr FROM l_sql
    DECLARE cl_xg_chk_column_gds_cs CURSOR FOR cl_xg_chk_column_gds_pr
    
    FOREACH cl_xg_chk_column_gds_cs INTO l_gds01,l_gds03,l_gds04
        IF cl_null(p_sql) THEN
           LET l_sql = "SELECT COUNT(",l_gds03,") FROM ",g_cr_db_str CLIPPED,p_table CLIPPED
           PREPARE cl_xg_chk_column_sql1_pr FROM l_sql
           EXECUTE cl_xg_chk_column_sql1_pr INTO l_cnt
           IF STATUS THEN
              CALL cl_err(l_gds03,'azz1297',1)
              CALL cl_xg_view_addlog(l_gds03||cl_getmsg('azz1297',g_lang)) #FUN-D20057
              LET g_success = 'N'
              EXIT FOREACH
           END IF
        ELSE
           LET l_sql = "SELECT COUNT(",l_gds03,") FROM ",p_table CLIPPED,
                       " WHERE ",p_where
           PREPARE cl_xg_chk_column_sql2_pr FROM l_sql
           EXECUTE cl_xg_chk_column_sql2_pr INTO l_cnt
           IF STATUS THEN
              CALL cl_err(l_gds03,'azz1297',1)
              CALL cl_xg_view_addlog(l_gds03||cl_getmsg('azz1297',g_lang)) #FUN-D20057
              LET g_success = 'N'
              EXIT FOREACH
           END IF
        END IF
    END FOREACH
    
END FUNCTION

FUNCTION cl_xg_view_bgjob(p_url)
DEFINE p_url     STRING
DEFINE req        com.HTTPRequest
DEFINE resp       com.HTTPResponse
DEFINE l_str      STRING

   TRY 
     LET req = com.HTTPRequest.Create(p_url)
     CALL req.doRequest()
     LET resp = req.getResponse()
     IF resp.getStatusCode() != 200 THEN
        DISPLAY "HTTP Error ("||resp.getStatusCode()||") ",resp.getStatusDescription()
     ELSE
        LET l_str = resp.getTextResponse()
        DISPLAY "HTTPResponse : OK!"
        DISPLAY l_str
     END IF
   CATCH
     DISPLAY "ERROR :",STATUS||" ("||SQLCA.SQLERRM||")" 
   END TRY

END FUNCTION


# Descriptions...: 取得收件人資料，設定是否直接郵寄
# Date & Author..: 2013/01/22 by odyliao FUN-CC0115
FUNCTION cl_xg_view_maillist(p_gdq)
DEFINE p_gdq    RECORD LIKE gdq_file.*
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_sql    STRING
DEFINE l_mlk    RECORD LIKE mlk_file.*

     LET l_sql = "SELECT * FROM mlk_file ",
                 " WHERE mlk01 = '",g_prog,"'",
                 " ORDER BY mlk02 "
     PREPARE cl_xg_view_mlk_pr FROM l_sql
     DECLARE cl_xg_view_mlk_cs CURSOR FOR cl_xg_view_mlk_pr
     LET l_cnt = 0
     FOREACH cl_xg_view_mlk_cs INTO l_mlk.*
         IF NOT cl_xg_view_chk_permission(l_mlk.mlk07,p_gdq.gdq43) THEN CONTINUE FOREACH END IF
         CASE l_mlk.mlk03
           WHEN "1" #收件人
                LET p_gdq.gdq37 = p_gdq.gdq37 CLIPPED,l_mlk.mlk05,",",l_mlk.mlk04,",",l_mlk.mlk07,"|"
                LET l_cnt = l_cnt + 1
           WHEN "2" #副本
                LET p_gdq.gdq38 = p_gdq.gdq38 CLIPPED,l_mlk.mlk05,",",l_mlk.mlk04,",",l_mlk.mlk07,"|"
                LET l_cnt = l_cnt + 1
           WHEN "3" #密件副本
                LET p_gdq.gdq39 = p_gdq.gdq39 CLIPPED,l_mlk.mlk05,",",l_mlk.mlk04,",",l_mlk.mlk07,"|"
                LET l_cnt = l_cnt + 1
         END CASE
     END FOREACH

     IF l_cnt >= 1 THEN
        IF g_bgjob = 'Y' THEN
           LET p_gdq.gdq45 = 'Y'
        END IF

        IF NOT cl_null(p_gdq.gdq37) THEN LET p_gdq.gdq37 = p_gdq.gdq37[1,LENGTH(p_gdq.gdq37)-1] END IF
        IF NOT cl_null(p_gdq.gdq38) THEN LET p_gdq.gdq38 = p_gdq.gdq38[1,LENGTH(p_gdq.gdq38)-1] END IF
        IF NOT cl_null(p_gdq.gdq39) THEN LET p_gdq.gdq39 = p_gdq.gdq39[1,LENGTH(p_gdq.gdq39)-1] END IF

     END IF

    #寄件者
     CALL cl_xg_view_mailsender(g_prog) RETURNING p_gdq.gdq41
    
     RETURN p_gdq.*

END FUNCTION

# Descriptions...: 取得寄件人
# Date & Author..: 2013/01/22 by odyliao FUN-CC0115
# Input Parameter: p_prog : 程式代號
# Return Code....: l_gdq41 : 寄件人信箱
FUNCTION cl_xg_view_mailsender(p_prog)
DEFINE l_mlj03  LIKE mlj_file.mlj03
DEFINE l_mlj05  LIKE mlj_file.mlj05
DEFINE l_mlj09  LIKE mlj_file.mlj09
DEFINE l_gdq41  LIKE gdq_file.gdq41
DEFINE l_str    STRING
DEFINE p_prog   LIKE type_file.chr10

   SELECT mlj03,mlj05,mlj09 INTO l_mlj03,l_mlj05,l_mlj09 
     FROM mlj_file WHERE mlj01=p_prog
   IF cl_null(l_mlj09) THEN LET l_mlj09="N" END IF

   #用使用者的Email當寄件者
   IF l_mlj09 = "N" THEN
      SELECT zx09 INTO l_gdq41 FROM zx_file  
       WHERE zx01 = g_user
      LET l_gdq41 = l_gdq41 CLIPPED
   END IF

   #用系統寄件者串Email當寄件者
   IF cl_null(l_gdq41) THEN
      LET l_str = l_mlj05 CLIPPED
      IF l_str.getindexof("@", 1) > 0 THEN
         LET l_gdq41 = l_mlj05 CLIPPED
      ELSE
         LET l_gdq41 = l_mlj05 CLIPPED,"@",l_mlj03 CLIPPED
      END IF
   END IF

   RETURN l_gdq41

END FUNCTION

FUNCTION cl_xg_view_logfile()
DEFINE     l_file  STRING,
           l_s     STRING,
           l_cmd   STRING,
           i       SMALLINT
DEFINE     p_interval     INTERVAL SECOND TO FRACTION(5)

    #記錄此次呼叫的 method name
    LET l_file = "xtragrid-", TODAY USING 'YYYYMMDD', ".log"
    LET channel = base.Channel.create()

    CALL channel.openFile(l_file,  "a")
    IF STATUS = 0 THEN
        CALL channel.setDelimiter("")
        #紀錄傳入的 XML 字串
        LET l_s = "#--------------------------- (", CURRENT YEAR TO SECOND, ") ----------------------------#"
        CALL channel.write(l_s)
        LET l_s = "Program:",g_prog, " , User:",g_user
        CALL channel.write(l_s)
        IF g_errlog.getlength() = 0 THEN #有錯誤
           CALL channel.write("Successful !")
           LET l_s = "#------------------------------------------------------------------------------#"
           CALL channel.write(l_s)
        ELSE
           CALL channel.write("Error : ")
           FOR i = 1 TO g_errlog.getlength()
               CALL channel.write(g_errlog[i])
           END FOR
           LET l_s = "#------------------------------------------------------------------------------#"
           CALL channel.write(l_s)
        END IF

        CALL channel.close()

        IF os.Path.chrwx(l_file CLIPPED,438) THEN END IF 
    END IF

END FUNCTION

#FUN-D20057 將錯誤訊息寫入陣列
FUNCTION  cl_xg_view_addlog(p_str)
DEFINE p_str   STRING
DEFINE l_n     LIKE type_file.num5

   LET l_n = g_errlog.getlength()
   LET g_errlog[l_n+1] = p_str

END FUNCTION

#FUN-D20057 取得匯出權限
FUNCTION cl_xg_view_export_permission() 
DEFINE l_zy06  LIKE zy_file.zy06

    LET l_zy06 = NULL
    SELECT zy06 INTO l_zy06 
      FROM zy_file
     WHERE zy01 = g_clas
       AND zy02 = g_prog
    RETURN l_zy06

END FUNCTION

FUNCTION cl_xg_view_export_filename(p_gdr00)
DEFINE p_gdr00  LIKE gdr_file.gdr00
DEFINE l_gcw    RECORD LIKE gcw_file.*
DEFINE l_gdr    RECORD LIKE gdr_file.*
DEFINE p_code   LIKE type_file.chr1
DEFINE  l_filename          STRING
DEFINE  l_min,l_max         LIKE type_file.num5
DEFINE  l_str               STRING
DEFINE  l_item_name         STRING
DEFINE l_zx02   LIKE zx_file.zx02
DEFINE l_zx04   LIKE zx_file.zx04
DEFINE l_gaz06  LIKE gaz_file.gaz06
DEFINE l_gaz03  LIKE gaz_file.gaz03
DEFINE l_time   LIKE type_file.chr100

      #檢查是否有自訂命名，若無則依標準命名
       SELECT * INTO l_gdr.* FROM gdr_file
        WHERE gdr00 = p_gdr00
       INITIALIZE l_gcw.* TO NULL
       SELECT * INTO l_gcw.* FROM gcw_file
        WHERE gcw01=l_gdr.gdr01
          AND gcw02=l_gdr.gdr02
          AND gcw03=l_gdr.gdr05
          AND gcw04=l_gdr.gdr04

      #有設定自訂檔名(gcw) 報表檔名第一段~第六段
       IF (NOT cl_null(l_gcw.gcw05)) OR (NOT cl_null(l_gcw.gcw06)) OR (NOT cl_null(l_gcw.gcw07)) OR (NOT cl_null(l_gcw.gcw08)) OR
          (NOT cl_null(l_gcw.gcw09)) OR (NOT cl_null(l_gcw.gcw10)) THEN
          SELECT zx02,zx04 INTO l_zx02,l_zx04 FROM zx_file WHERE zx01 = g_user   #使用者名稱/權限類別
          SELECT gaz03,gaz06 INTO l_gaz03,l_gaz06 FROM gaz_file                  #多語系程式名稱/報表抬頭
           WHERE gaz01=g_prog AND gaz02=g_rlang
          IF cl_null(l_gaz06) THEN
             LET l_gaz06 = l_gaz03 CLIPPED
          END IF
          LET l_time=TIME
          LET p_code = l_gdr.gdr01
          LET l_item_name = g_prog CLIPPED,"|",l_gaz06 CLIPPED,"|",g_plant CLIPPED,"|",g_dbs CLIPPED,"|",g_user CLIPPED,"|",l_zx02 CLIPPED,"|",g_pdate CLIPPED,"|", l_time CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw05) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw06) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw07) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw08) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw09) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          CALL cl_prt_filename(l_item_name,l_gcw.gcw10) RETURNING l_str  #CR報表檔名設定
          LET l_filename = l_filename CLIPPED,l_str CLIPPED
          #刪除最後一個分隔符號
          LET l_str = l_filename CLIPPED
          LET l_str = l_str.substring(1,l_str.getLength()-1) CLIPPED
          LET l_filename = l_str CLIPPED
       ELSE  #不自訂命名，依標準命名
          LET l_filename = g_plant, "_", g_prog CLIPPED, "_", g_user   #組合檔名
       END IF
 
       RETURN l_filename

END FUNCTION

#動態控制欄位隱藏顯示
FUNCTION cl_xg_column_visible(p_str,p_column,p_value)
DEFINE p_str      LIKE type_file.chr1000
DEFINE p_column   LIKE type_file.chr100
DEFINE p_value    LIKE type_file.chr1

    IF p_value NOT MATCHES '[YN]' THEN RETURN p_str END IF

    IF cl_null(p_str) THEN
       LET p_str = p_column,",",p_value
    ELSE
       LET p_str = p_str CLIPPED,"|",p_column,",",p_value
    END IF
    
    RETURN p_str

END FUNCTION

#FUN-D30056---(S)
#取得預設群組
FUNCTION cl_xg_view_gds36(p_gdr00)
DEFINE p_gdr00  LIKE gdr_file.gdr00
DEFINE l_grups  LIKE gdr_file.gdr16
DEFINE l_n      LIKE type_file.num5
DEFINE l_gds03  LIKE gds_file.gds03
DEFINE l_gds36  LIKE gds_file.gds36

    LET l_grups = NULL
    DECLARE p_xg_view_gds36_cs CURSOR FOR 
     SELECT gds03,gds36 FROM gds_file
      WHERE gds00 = p_gdr00
        AND gds36 IS NOT NULL
      ORDER BY gds36
    LET l_n = 1
    FOREACH p_xg_view_gds36_cs INTO l_gds03,l_gds36
       IF cl_null(l_gds03) THEN CONTINUE FOREACH END IF
       IF l_n = 1 THEN
          LET l_grups = l_gds03
       ELSE
          LET l_grups = l_grups CLIPPED,",",l_gds03 CLIPPED 
       END IF
       LET l_n = l_n + 1
    END FOREACH
   
    IF cl_null(l_grups) THEN LET l_grups = " " END IF

    RETURN l_grups

END FUNCTION
#FUN-D30056---(E)

#轉換英數字成為序號
FUNCTION cl_xg_get_pnum(p_num)
DEFINE p_num LIKE type_file.chr1
DEFINE j     LIKE type_file.num5

    CASE p_num
       WHEN "1" LET j = 1
       WHEN "2" LET j = 2
       WHEN "3" LET j = 3
       WHEN "4" LET j = 4
       WHEN "5" LET j = 5
       WHEN "6" LET j = 6
       WHEN "7" LET j = 7
       WHEN "8" LET j = 8
       WHEN "9" LET j = 9
       WHEN "A" LET j = 10
       WHEN "a" LET j = 10
       WHEN "B" LET j = 11
       WHEN "b" LET j = 11
       WHEN "C" LET j = 12
       WHEN "c" LET j = 12
       WHEN "D" LET j = 13
       WHEN "d" LET j = 13
       WHEN "E" LET j = 14
       WHEN "e" LET j = 14
       WHEN "F" LET j = 15
       WHEN "f" LET j = 15
       WHEN "G" LET j = 16
       WHEN "g" LET j = 16
       WHEN "H" LET j = 17
       WHEN "h" LET j = 17
       WHEN "I" LET j = 18
       WHEN "i" LET j = 18
    END CASE
   
   RETURN j

END FUNCTION

#FUN-D40059 ----start
#aooi998與p_zy2檔案權限勾稽
FUNCTION cl_xg_view_chk_permission(p_mlk07,p_gdq43)
DEFINE p_mlk07  LIKE mlk_file.mlk07
DEFINE p_gdq43  LIKE gdq_file.gdq43
DEFINE l_str    STRING
DEFINE l_chk    LIKE type_file.num5

    IF cl_null(p_gdq43) THEN RETURN TRUE END IF

    LET l_str = p_gdq43
    LET l_chk = TRUE
    CASE p_mlk07
      WHEN "1" #PDF
         IF l_str.getIndexOf("P",1) <=0 THEN LET l_chk=FALSE END IF
      WHEN "2" #EXCEL
         IF (l_str.getIndexOf("E",1) <=0) AND (l_str.getIndexOf("X",1) <=0) THEN
            LET l_chk=FALSE 
         END IF
      WHEN "3" #WORD
         IF l_str.getIndexOf("D",1) <=0 THEN LET l_chk=FALSE END IF
      WHEN "4" #CSV
         IF l_str.getIndexOf("C",1) <=0 THEN LET l_chk=FALSE END IF
    END CASE

    RETURN l_chk

END FUNCTION
#FUN-D40059 ----end
