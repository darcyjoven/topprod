# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: admp210.4gl
# Descriptions...: B2C電子發票匯出作業 
# Date & Author..: No.FUN-C70030 12/07/11 By pauline 
# Modify.........: No.FUN-C80002 12/08/02 By pauline axrt311 新增ome81,ome82欄位,一張發票匯出一份xml
# Modify.........: No.FUN-C80038 12/08/10 By pauline 1.買方無統編時, 一律匯出 '0000000000'   2.日期格式, 修正為 'YYYY-MM-DD' 

IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_before_input_done    STRING
DEFINE   g_sql                  STRING
DEFINE   g_wc                   STRING
DEFINE   g_ama01                LIKE ama_file.ama01 
DEFINE   g_rec_b                LIKE type_file.num10
DEFINE   g_rec_b1               LIKE type_file.num10
DEFINE   g_cnt                  LIKE type_file.num10
DEFINE   g_curs_index           LIKE type_file.num10
DEFINE   g_row_count            LIKE type_file.num10
DEFINE   g_jump                 LIKE type_file.num10
DEFINE   g_msg                  LIKE ze_file.ze03
DEFINE   mi_need_cons           LIKE type_file.num5
DEFINE   g_count                LIKE type_file.num10
DEFINE   g_renew                LIKE type_file.num5
DEFINE   g_wpc                  RECORD LIKE wpc_file.*
DEFINE   g_channel              base.Channel
DEFINE   g_tmpstr               STRING
DEFINE   g_path                 STRING
DEFINE   g_flag                 LIKE type_file.chr1
DEFINE   g_ama04                LIKE ama_file.ama04
DEFINE   g_ama05                LIKE ama_file.ama05
DEFINE   g_ama07                LIKE ama_file.ama07
DEFINE   g_ama11                LIKE ama_file.ama11
DEFINE   g_ama106               LIKE ama_file.ama106
DEFINE   g_ama107               LIKE ama_file.ama107
DEFINE   g_ama108               LIKE ama_file.ama108
DEFINE   g_ama106_str           STRING
DEFINE   lc_cmd                 STRING 
DEFINE   g_filename             LIKE ome_file.omexml   #FUN-C80002 add
DEFINE   g_ome                  DYNAMIC ARRAY OF RECORD LIKE ome_file.*
DEFINE   g_idx                  LIKE type_file.num10
MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF

   LET g_ama01 = ARG_VAL(1)
   LET g_path = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF g_bgjob IS NULL THEN
      LET g_bgjob='N'
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   WHILE TRUE
      IF g_bgjob = 'N' THEN
         LET g_success = 'Y'
         CALL p210_tm()
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF NOT cl_sure(20,20) THEN EXIT WHILE END IF
         CALL cl_wait()
         CALL t210_p()
         IF g_success = 'Y' THEN
            CALL cl_end2(1) RETURNING g_flag
         ELSE
            CALL cl_end2(2) RETURNING g_flag
         END IF
         IF g_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p210_w
            EXIT WHILE
         END IF   
      ELSE
         LET g_success = 'Y'
         CALL t210_p()
         EXIT WHILE
      END IF
   END WHILE      
                  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN       
               
FUNCTION p210_tm()
DEFINE l_n           LIKE type_file.num5
               
   OPEN WINDOW p210_w WITH FORM "amd/42f/amdp210"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_init()
               
   LET g_path = "C:\\tiptop\\" 
   LET g_path = g_path.trim()
   DISPLAY g_path TO path

   INPUT g_ama01 FROM ama01
      AFTER FIELD ama01
         IF cl_null(GET_FLDBUF(ama01)) THEN
            NEXT FIELD ama01
         ELSE
            LET l_n = 0 
            SELECT COUNT(*) INTO l_n FROM ama_file
              WHERE ama01 = g_ama01
            IF cl_null(l_n) OR l_n = 0 THEN
               CALL cl_err('','axr018',0)
               NEXT FIELD ama01
            END IF
            LET g_sql = " SELECT ama04,ama05,ama07,ama11,ama106,ama107,ama108 " ,
                        "   FROM ama_file ",
                        "    WHERE ama01 = '",g_ama01,"'"
            PREPARE p210_prepare9 FROM g_sql
            DECLARE p210_cs9 CURSOR FOR p210_prepare9
            EXECUTE p210_cs9 INTO g_ama04,g_ama05,g_ama07,g_ama11,
                                  g_ama106, g_ama107, g_ama108
            IF cl_null(g_ama106) OR cl_null(g_ama107) OR cl_null(g_ama108) THEN
               CALL cl_err('','axr013',1)
               NEXT FIELD ama01
            END IF
         END IF 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ama01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ama"
               CALL cl_create_qry() RETURNING g_ama01 
               DISPLAY g_ama01 TO ama01 
               NEXT FIELD ama01
         END CASE 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW p203_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   INPUT g_path,g_bgjob FROM path,g_bgjob
     #WITHOUT DEFAULTS

      BEFORE INPUT
           LET g_before_input_done = FALSE
           LET g_before_input_done = TRUE

      BEFORE FIELD path
           LET g_path = " C:\\tiptop\\"
           DISPLAY g_path TO path
 
      AFTER FIELD path 
         IF cl_null(GET_FLDBUF(path)) THEN
            NEXT FIELD path 
         END IF


      AFTER INPUT
         IF INT_FLAG THEN
            RETURN
         END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()


      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

   END INPUT

   IF INT_FLAG THEN
      RETURN
   END IF

   IF g_bgjob = "Y" THEN
     LET lc_cmd = lc_cmd CLIPPED,
                  " '",g_ama01 CLIPPED,"'",
                  " '",g_path CLIPPED,"'",
                  " '",g_bgjob CLIPPED,"'"
     CALL cl_cmdat('amdp210',g_time,lc_cmd CLIPPED)
     CLOSE WINDOW p210_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
   END IF
END FUNCTION 



FUNCTION t210_p()
 DEFINE l_ome              RECORD LIKE ome_file.*
 DEFINE l_filename         LIKE ome_file.omexml 
 DEFINE l_time             LIKE ome_file.omevoidt  
#DEFINE l_n                LIKE type_file.num5    #FUN-C80002 mark
 DEFINE l_n                LIKE type_file.num20   #FUN-C80002 add
 DEFINE l_i                LIKE type_file.num10   #FUN-C80002 add
 DEFINE l_filename2        LIKE ome_file.omexml 

  #FUN-C80002 mark START
  #拉出去成為獨立function
  ##組出檔案名稱
  #LET g_success = 'Y'
  #LET l_filename = TODAY USING "yyyymmdd"
  #LET l_time = TIME
  #LET l_time = cl_replace_str(l_time,":","")
  #LET l_filename = l_filename CLIPPED ,l_time CLIPPED
  #LET g_filename = l_filename    #FUN-C80002 add  
  #LET g_sql = " SELECT COUNT(*) FROM ome_file ",
  #            "   WHERE omexml LIKE '",l_filename,"%'"   
  #PREPARE p210_prepare FROM g_sql
  #DECLARE p210_cs CURSOR FOR p210_prepare
  #EXECUTE p210_cs INTO l_n
  #IF l_n = 0 OR cl_null(l_n) THEN
  #   LET l_n = 1  
  #END IF
  #
  #LET l_filename2 = l_n USING "&"
  #LET l_filename = l_filename,l_filename2
  #FUN-C80002 mark END 
   CALL p210_filename1()  #FUN-C80002 add

  #判斷是否電子發票相關欄位是否正常維護
   LET g_sql = " SELECT ama04,ama05,ama07,ama11,ama106,ama107,ama108 " ,
               "   FROM ama_file ",
               "    WHERE ama01 = '",g_ama01,"'"
   PREPARE p210_prepare1 FROM g_sql
   DECLARE p210_cs1 CURSOR FOR p210_prepare1    
   EXECUTE p210_cs1 INTO g_ama04,g_ama05,g_ama07,g_ama11,
                         g_ama106, g_ama107, g_ama108
   IF cl_null(g_ama106) OR cl_null(g_ama107) OR cl_null(g_ama108) THEN
      CALL cl_err('','axr013',1)
      LET g_success = 'N'
      RETURN
   END IF

  #LET g_ama106_str = g_ama106 USING "YYYYMMDD"  #FUN-C80038 mark
   LET g_ama106_str = g_ama106 USING "YYYY-MM-DD"  #FUN-C80038 add

  #FUN-C80002 mark START 
  ##匯出正常發票
  #BEGIN WORK
  #LET g_success = 'Y'
  #UPDATE ome_file SET omexml = l_filename 
  #      WHERE ome00 = '1' AND ome22 = 'Y' 
  #        AND (omexml IS NULL OR omexml = ' ' )
  #        AND omevoid = 'N' AND omecncl = 'N'
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err3("upd","oma_file",'',"",SQLCA.sqlcode,"","upd omaxml",1)  
  #   LET g_success = 'N'
  #END IF
  #IF g_success = 'Y' THEN
  #   CALL p210_xml1(l_filename)
  #   IF g_success = 'N' THEN
  #      ROLLBACK WORK
  #      RETURN
  #   ELSE
  #      COMMIT WORK
  #   END IF
  #END IF
  #FUN-C80002 mark START

  ##匯出作廢發票
  #BEGIN WORK
  #LET g_success = 'Y'
  #UPDATE ome_file SET omexml = l_filename
  #      WHERE ome00 = '1' AND ome22 = 'Y'
  #        AND (omexml IS NULL OR omexml = ' ' )
  #        AND omevoid = 'Y' AND omecncl = 'N'
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err3("upd","oma_file",'',"",SQLCA.sqlcode,"","upd omaxml",1)  
  #   LET g_success = 'N'
  #END IF
  #IF g_success = 'Y' THEN
  #   CALL p210_xml2(l_filename)
  #   IF g_success = 'N' THEN
  #      ROLLBACK WORK
  #      RETURN
  #   ELSE  
  #      COMMIT WORK
  #   END IF
  #END IF 

  ##匯出註銷發票
  #BEGIN WORK
  #LET g_success = 'Y'
  #UPDATE ome_file SET omexml = l_filename
  #      WHERE ome00 = '1' AND ome22 = 'Y'
  #        AND (omexml IS NULL OR omexml = ' ' )
  #        AND omevoid = 'N' AND omecncl = 'Y'
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err3("upd","oma_file",'',"",SQLCA.sqlcode,"","upd omaxml",1)  
  #   LET g_success = 'N'
  #END IF
  #IF g_success = 'Y' THEN
  #   CALL p210_xml3(l_filename)
  #   IF g_success = 'N' THEN
  #      ROLLBACK WORK
  #      RETURN
  #   ELSE
  #      COMMIT WORK
  #   END IF
  #END IF   
  #FUN-C80002 mark START

  #FUN-C80002 add START
   #將未匯出xml但是已作廢的發票資料放入到temp table內
   DROP TABLE ome_temp
   SELECT * FROM ome_file WHERE 1 = 0 INTO TEMP ome_temp
   DELETE FROM ome_temp
   INSERT INTO ome_temp SELECT ome_file.* FROM ome_file 
                         WHERE (omexml IS NULL OR omexml = ' ' )
                           AND ome81 = 1
                           AND ome00 = '1'
                           AND ome22 = 'Y'
                           AND omevoid = 'Y' AND omecncl = 'N'

   LET l_i = 1 
   CALL p210_get_ome()
   FOR l_i = 1 TO g_idx
      IF cl_null(g_ome[l_i].ome01) THEN CONTINUE FOR END IF
      IF g_ome[l_i].omevoid = 'N' AND g_ome[l_i].omecncl = 'N' THEN   #匯出正常發票
         WHILE TRUE
            CALL p210_filename2('1') RETURNING l_filename
            IF NOT cl_null(l_filename) THEN   
               EXIT WHILE
            ELSE
               CALL p210_filename1()
            END IF
         END WHILE 
         BEGIN WORK
         UPDATE ome_file SET omexml = l_filename,
                             ome81 = '2'
                 WHERE ome01 = g_ome[l_i].ome01
                   AND ome00 = g_ome[l_i].ome00
                   AND ome22 = g_ome[l_i].ome22
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ome_file",'',"",SQLCA.sqlcode,"","upd omexml",1)
            ROLLBACK WORK
            LET g_success = 'N'
         ELSE
            COMMIT WORK
            CALL p210_xml1(l_filename,g_ome[l_i].*)
         END IF
      END IF
      IF g_ome[l_i].omevoid = 'Y' AND g_ome[l_i].omecncl = 'N' THEN   #匯出作廢發票
         #因為在pos端有機會當場開出的發票,當場作廢,但是在tiptop只會有一筆作廢的發票資料,
         #但是在匯出xml時,必須要將當場作廢的發票也匯出一份發票訊息到正常發票內
         #所以增加了ome81判斷是否已經將資料匯出到xml內
         #若是已作廢發票但是ome81為未匯出時,此張發票就必須要重複匯出一份到C0401內
         WHILE TRUE
            CALL p210_filename2(2) RETURNING l_filename
            IF NOT cl_null(l_filename) THEN
               EXIT WHILE
            ELSE
               CALL p210_filename1()
            END IF
         END WHILE
         BEGIN WORK
         UPDATE ome_file SET omexml = l_filename,
                             ome81 = '2'
                 WHERE ome01 = g_ome[l_i].ome01
                   AND ome00 = g_ome[l_i].ome00
                   AND ome22 = g_ome[l_i].ome22
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ome_file",'',"",SQLCA.sqlcode,"","upd omexml",1)
            ROLLBACK WORK
            LET g_success = 'N'
         ELSE
            COMMIT WORK
            CALL p210_xml2(l_filename,g_ome[l_i].*)
            SELECT COUNT(*) INTO l_n FROM ome_temp
               WHERE ome01 = g_ome[l_i].ome01
                 AND ome00 = g_ome[l_i].ome00
                 AND ome22 = g_ome[l_i].ome22
            IF l_n = 1  THEN
               CALL p210_xml1(l_filename,g_ome[l_i].*)
            END IF
         END IF
      END IF
      IF g_ome[l_i].omevoid = 'N' AND g_ome[l_i].omecncl = 'Y' THEN   #匯出註銷發票
         WHILE TRUE
            CALL p210_filename2(3) RETURNING l_filename
            IF NOT cl_null(l_filename) THEN
               EXIT WHILE 
            ELSE
               CALL p210_filename1()
            END IF
         END WHILE
         BEGIN WORK
         UPDATE ome_file SET omexml = l_filename,
                             ome81 = '2'
                 WHERE ome01 = g_ome[l_i].ome01
                   AND ome00 = g_ome[l_i].ome00
                   AND ome22 = g_ome[l_i].ome22
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","ome_file",'',"",SQLCA.sqlcode,"","upd omexml",1)
            ROLLBACK WORK
            LET g_success = 'N'
         ELSE
            COMMIT WORK
            CALL p210_xml3(l_filename,g_ome[l_i].*)
         END IF
      END IF
   END FOR
  #FUN-C80002 add END
   
END FUNCTION 

#FUNCTION p210_xml1(p_filename)   #產生C0401 xml   #FUN-C80002 mark 
FUNCTION p210_xml1(p_filename,l_ome)   #FUN-C80002 add
DEFINE l_ome               RECORD LIKE ome_file.*
DEFINE l_n                 LIKE type_file.num5
DEFINE p_filename          STRING
DEFINE l_filename          STRING
DEFINE l_cmd               STRING
DEFINE l_str               STRING
DEFINE ms_codeset          STRING
DEFINE lc_channe1          base.Channel
DEFINE window_path         STRING
DEFINE l_invoicetype       LIKE type_file.chr2
DEFINE l_donatemark        LIKE type_file.chr1
DEFINE l_printmark         LIKE type_file.chr1
DEFINE l_oga01             LIKE oga_file.oga01
DEFINE l_ogb03             LIKE oga_file.oga03
DEFINE l_ogb03_str         STRING 
DEFINE l_ogb05             LIKE ogb_file.ogb05
DEFINE l_ogb06             LIKE ogb_file.ogb06
DEFINE l_ogb12             LIKE ogb_file.ogb12
DEFINE l_ogb12_str         STRING 
DEFINE l_ogb13             LIKE ogb_file.ogb13
DEFINE l_ogb14t            LIKE ogb_file.ogb14t
DEFINE l_ogb14t_str        STRING 
DEFINE l_ogi05             LIKE ogi_file.ogi05
DEFINE l_ogi07             LIKE ogi_file.ogi07
DEFINE l_unitprice         LIKE type_file.num20_6
DEFINE l_unitprice_str     STRING 
DEFINE l_taxtype           LIKE type_file.chr1
DEFINE l_taxrate           LIKE type_file.num20_6
DEFINE l_taxrate_str       STRING 
DEFINE l_ome02             STRING
DEFINE l_ome59x            STRING
DEFINE l_ome59t            STRING
DEFINE l_ome78             STRING
DEFINE l_ome79             STRING
DEFINE l_ome80             STRING

  #FUN-C80002 mark START
  #LET g_sql = " SELECT COUNT(*) FROM ome_file ",
  #            "   WHERE ome00 = '1' AND ome22 = 'Y' ",
  #            "     AND rtrim(omexml) = '",p_filename,"'",
  #            "     AND (   (omevoid = 'N' AND omecncl = 'N') "   
  #PREPARE p210_prepare3 FROM g_sql
  #DECLARE p210_cs3 CURSOR FOR p210_prepare3
  #EXECUTE p210_cs3 INTO l_n 
  #IF l_n = 0 OR cl_null(l_n) THEN
  #   RETURN
  #END IF
  #LET g_sql = " SELECT * FROM ome_file ",
  #            "   WHERE ome00 = '1' AND ome22 = 'Y' ",
  #            "     AND rtrim(omexml) = '",p_filename,"' ",
  #            "     AND (   (omevoid = 'N' AND omecncl = 'N') "
  #PREPARE p210_prepare2 FROM g_sql
  #DECLARE p210_cs2 CURSOR FOR p210_prepare2
  #FUN-C80002 mark END

   LET p_filename = "C0401-",p_filename
   LET p_filename = p_filename,".xml"

   IF g_bgjob = 'N' THEN
      LET l_filename = fgl_getenv("TEMPDIR"), "/",p_filename 
   ELSE
      LET l_filename = g_path,p_filename
   END IF
   LET lc_channe1 = base.Channel.create()
   CALL lc_channe1.openFile(l_filename,"w")
   IF STATUS THEN 
      LET g_success = 'N' 
      RETURN
   END IF
   CALL lc_channe1.setDelimiter("")
   LET ms_codeset = cl_get_codeset()
   LET l_str = '<?xml version="1.0" encoding="UTF-8"?>'
   CALL lc_channe1.write(l_str)
  #FUN-C80002 add START
   LET l_str = '<Invoice xsi:schemaLocation="urn:GEINV:eInvoiceMessage:C0401:3.0 C0401.xsd" xmlns="urn:GEINV:eInvoiceMessage:C0401:3.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'   
   CALL lc_channe1.write(l_str)
  #FUN-C80002 add END
  #FOREACH p210_cs2 INTO l_ome.*   #FUN-C80002 mark 
      LET l_oga01 = NULL 
      SELECT oga01 INTO l_oga01 FROM oga_file WHERE oga98 = l_ome.ome72
      CALL p210_train(10,l_ome.ome01) RETURNING l_ome.ome01 
     #LET l_ome02 = l_ome.ome02 USING 'YYYYMMDD'   #FUN-C80038 mark
      LET l_ome02 = l_ome.ome02 USING 'YYYY-MM-DD'
      CALL p210_train(10,l_ome.ome60) RETURNING l_ome.ome60
      CALL p210_train(60,g_ama07) RETURNING g_ama07
      CALL p210_train(100,g_ama05) RETURNING g_ama05
      CALL p210_train(12,g_ama11) RETURNING g_ama11 
      CALL p210_train(10,l_ome.ome042) RETURNING l_ome.ome042
      IF cl_null(l_ome.ome042) THEN LET l_ome.ome042 = '0000000000' END IF   #FUN-C80038 add
      CALL p210_train(60,l_ome.ome043) RETURNING l_ome.ome043
      CALL p210_train(100,l_ome.ome044) RETURNING l_ome.ome044    
      CALL p210_train(40,g_ama04) RETURNING g_ama04
      CALL p210_train(40,g_ama107) RETURNING g_ama107 
      CALL p210_train(20,g_ama108) RETURNING g_ama108 
      CALL p210_train(6,l_ome.ome23) RETURNING l_ome.ome23 
      CALL p210_train(64,l_ome.ome24) RETURNING l_ome.ome24 
      CALL p210_train(64,l_ome.ome241) RETURNING l_ome.ome241 
      CALL p210_train(10,l_ome.ome25) RETURNING l_ome.ome25 
      CALL p210_train(4,l_ome.ome26) RETURNING l_ome.ome26  

     #發票類別
      IF l_ome.ome212 = '5' THEN
         LET l_invoicetype = '03'
      ELSE
         IF l_ome.ome212 = '6' THEN
            LET l_invoicetype = '06'
         END IF
      END IF
     #捐贈註記
      IF cl_null(l_ome.ome25) THEN
         LET l_donatemark = '0'
      ELSE
         LET l_donatemark = '1'
      END IF
     #紙本發票已列印否註記
      IF l_ome.omeprsw = 0 OR cl_null(l_ome.omeprsw) THEN
         LET l_printmark = 'N'
      ELSE
         LET l_printmark = 'Y'
      END IF 
     #發票資料
     #LET l_str = '<Invoice>'        #FUN-C80002 mark
     #CALL lc_channe1.write(l_str)   #FUN-C80002 mark
      LET l_str = '    <Main> ' 
      CALL lc_channe1.write(l_str)
      LET l_str = "        <InvoiceNumber>",l_ome.ome01 CLIPPED,"</InvoiceNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <InvoiceDate>",l_ome02 CLIPPED,"</InvoiceDate>"
      CALL lc_channe1.write(l_str)
     #LET l_str = "        <InvoiceTime></InvoiceTime>"                          #FUN-C80002 mark
      LET l_str = "        <InvoiceTime>",l_ome.ome82 CLIPPED,"</InvoiceTime>"   #FUN-C80002 add
      CALL lc_channe1.write(l_str)
      LET l_str = "        <Seller>   " 
      CALL lc_channe1.write(l_str)
      LET l_str = "            <Identifier>",l_ome.ome60 CLIPPED,"</Identifier>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <Name>",g_ama07 CLIPPED,"</Name>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <Address>",g_ama05 CLIPPED,"</Address>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <PersonInCharge>",g_ama11 CLIPPED,"</PersonInCharge>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <TelephoneNumber></TelephoneNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <FacsimileNumber></FacsimileNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <EmailAddress></EmailAddress>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <CustomerNumber></CustomerNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <RoleRemark></RoleRemark>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        </Seller> "
      CALL lc_channe1.write(l_str)  
      LET l_str = "        <Buyer>   "
      CALL lc_channe1.write(l_str)
      LET l_str = "            <Identifier>",l_ome.ome042 CLIPPED,"</Identifier>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <Name>",l_ome.ome043 CLIPPED,"</Name>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <Address>",l_ome.ome044 CLIPPED,"</Address>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <PersonInCharge></PersonInCharge>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <TelephoneNumber></TelephoneNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <FacsimileNumber></FacsimileNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <EmailAddress></EmailAddress>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <CustomerNumber></CustomerNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "            <RoleRemark></RoleRemark>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        </Buyer> "
      CALL lc_channe1.write(l_str)
      LET l_str = "        <CheckNumber></CheckNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <BuyerRemark></BuyerRemark>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <MainRemark></MainRemark>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <CustomerClearanceMark></CustomerClearanceMark>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <TaxCenter>",g_ama04 CLIPPED,"</TaxCenter>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <PermitDate>",g_ama106_str CLIPPED,"</PermitDate>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <PermitWord>",g_ama107 CLIPPED,"</PermitWord>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <PermitNumber>",g_ama108 CLIPPED,"</PermitNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <Category></Category>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <RelateNumber></RelateNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <InvoiceType>",l_invoicetype CLIPPED,"</InvoiceType>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <GroupMark></GroupMark>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <DonateMark>",l_donatemark CLIPPED,"</DonateMark>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <CarrierType>",l_ome.ome23 CLIPPED,"</CarrierType>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <CarrierId1>",l_ome.ome24 CLIPPED,"</CarrierId1>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <CarrierId2>",l_ome.ome241 CLIPPED,"</CarrierId2>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <PrintMark>",l_printmark CLIPPED,"</PrintMark>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <NPOBAN>",l_ome.ome25 CLIPPED,"</NPOBAN>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <RandomNumber>",l_ome.ome26 CLIPPED,"</RandomNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = '    </Main> '
      CALL lc_channe1.write(l_str)
     #購買商品資料
      LET l_str = '    <Details> '
      CALL lc_channe1.write(l_str)
      LET g_sql = " SELECT ogb03,ogb05,ogb06,ogb12,ogb13,ogb14t ",
                  "   FROM ogb_file WHERE ogb01 = '",l_oga01,"' "
      PREPARE p210_prepare4 FROM g_sql
      DECLARE p210_cs4 CURSOR FOR p210_prepare4
      FOREACH p210_cs4 INTO l_ogb03,l_ogb05,l_ogb06,l_ogb12,l_ogb13,l_ogb14t
        
         SELECT ogi05,ogi07 INTO l_ogi05,l_ogi07 
           FROM ogi_file
            WHERE ogi01 = l_oga01 AND ogi02 = l_ogb03 AND ogi06 = 0 

         CALL p210_train(256,l_ogb06) RETURNING l_ogb06
         CALL p210_train(6,l_ogb05) RETURNING l_ogb05
         CALL p210_train(3,l_ogb03) RETURNING l_ogb03_str
         CALL p210_train2(l_ogb12) RETURNING l_ogb12_str
         CALL p210_train2(l_ogb14t) RETURNING l_ogb14t_str 
         IF l_ogi07 = 'Y' THEN
            LET l_unitprice = l_ogb13
         ELSE
            LET l_unitprice = l_ogb13 * (1 + (l_ogi05/100))
         END IF
         CALL p210_train2(l_unitprice) RETURNING l_unitprice_str

         LET l_str = '        <ProductItem> '
         CALL lc_channe1.write(l_str)
         LET l_str = "            <Description>",l_ogb06 CLIPPED,"</Description>"
         CALL lc_channe1.write(l_str)
         LET l_str = "            <Quantity>",l_ogb12_str CLIPPED,"</Quantity>"
         CALL lc_channe1.write(l_str)
         LET l_str = "            <Unit>",l_ogb05 CLIPPED,"</Unit>"
         CALL lc_channe1.write(l_str)
         LET l_str = "            <UnitPrice>",l_unitprice_str CLIPPED,"</UnitPrice>"
         CALL lc_channe1.write(l_str)
         LET l_str = "            <Amount>",l_ogb14t_str CLIPPED,"</Amount>"
         CALL lc_channe1.write(l_str)
         LET l_str = "            <SequenceNumber>",l_ogb03_str CLIPPED,"</SequenceNumber>"
         CALL lc_channe1.write(l_str)
         LET l_str = "            <Remark></Remark>"
         CALL lc_channe1.write(l_str)
         LET l_str = "            <RelateNumber></RelateNumber>"
         CALL lc_channe1.write(l_str)
         LET l_str = '        </ProductItem> '
         CALL lc_channe1.write(l_str)
      END FOREACH
      LET l_str = '    </Details> '
      CALL lc_channe1.write(l_str)
     #匯總資料
     #課稅別
      IF l_ome.ome78 > 0 THEN
         IF l_ome.ome79 = 0 AND l_ome.ome80 = 0 THEN
            LET l_taxtype = 1
         ELSE 
            LET l_taxtype = 9
         END IF
      ELSE
         IF l_ome.ome79 > 0 AND l_ome.ome80 = 0 THEN
            LET l_taxtype = 2
         END IF
         IF l_ome.ome79 = 0 AND l_ome.ome80 > 0 THEN
            LET l_taxtype = 3
         END IF
      END IF
     #稅率  取最大稅率
      SELECT MAX(ogi05) INTO l_taxrate FROM ogi_file
         WHERE ogi01 = l_oga01 AND ogi06 = 0
      IF cl_null(l_taxrate) THEN LET l_taxrate = 0 END IF
      LET l_taxrate = l_taxrate / 100
      CALL p210_train2(l_ome.ome78) RETURNING l_ome78 
      CALL p210_train2(l_ome.ome80) RETURNING l_ome80
      CALL p210_train2(l_ome.ome79) RETURNING l_ome79
      CALL p210_train2(l_taxrate) RETURNING l_taxrate_str
      CALL p210_train2(l_ome.ome59x) RETURNING l_ome59x
      CALL p210_train2(l_ome.ome59t) RETURNING l_ome59t

      LET l_str = '    <Amount> '
      CALL lc_channe1.write(l_str)
      LET l_str = "        <SalesAmount>",l_ome78 CLIPPED,"</SalesAmount>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <FreeTaxSalesAmount>",l_ome80 CLIPPED,"</FreeTaxSalesAmount>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <ZeroTaxSalesAmount>",l_ome79 CLIPPED,"</ZeroTaxSalesAmount>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <TaxType>",l_taxtype CLIPPED,"</TaxType>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <TaxRate>",l_taxrate_str CLIPPED,"</TaxRate>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <TaxAmount>",l_ome59x CLIPPED,"</TaxAmount>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <TotalAmount>",l_ome59t CLIPPED,"</TotalAmount>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <DiscountAmount></DiscountAmount>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <OriginalCurrencyAmount></OriginalCurrencyAmount>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <ExchangeRate></ExchangeRate>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <Currency></Currency>"
      CALL lc_channe1.write(l_str)
      LET l_str = '    </Amount> '
      CALL lc_channe1.write(l_str)
      LET l_str = '</Invoice>'
      CALL lc_channe1.write(l_str)
  #END FOREACH   #FUN-C80002 mark
   CALL lc_channe1.close()
   LET g_path = g_path.toLowerCase( )
   LET g_path = g_path.trim()
   LET window_path = g_path,p_filename
 
   IF g_bgjob = 'N' THEN  
      LET status = cl_download_file(l_filename, window_path)
      IF status then
        #CALL cl_err(p_filename,"amd-040",1)  #FUN-C80002 mark
         DISPLAY "Download OK!!"
      ELSE
        #CALL cl_err(p_filename,"amd-041",1)  #FUN-C80002 mark
         DISPLAY "Download fail!!"
         LET g_success = 'N'
      END IF
 
      LET l_cmd = "rm ",l_filename CLIPPED," 2>/dev/null"
      DISPLAY l_cmd
      RUN l_cmd
      LET l_cmd = "rm ",l_filename CLIPPED," 2>/dev/null"
      DISPLAY l_cmd
      RUN l_cmd
   END IF
END FUNCTION

#FUNCTION p210_xml2(p_filename)   #產生C0501 xml  #FUN-C80002 mark 
FUNCTION p210_xml2(p_filename,l_ome)    #FUN-C80002 add
DEFINE l_ome               RECORD LIKE ome_file.*
DEFINE p_filename          STRING
DEFINE l_filename          STRING
DEFINE l_n                 LIKE type_file.num5
DEFINE l_cmd               STRING
DEFINE l_str               STRING
DEFINE ms_codeset          STRING
DEFINE lc_channe1          base.Channel
DEFINE window_path         STRING
DEFINE l_ome02             STRING
DEFINE l_omevoidd          STRING
DEFINE l_azf03             LIKE azf_file.azf03

  #FUN-C80002 mark START
  #LET g_sql = " SELECT COUNT(*) FROM ome_file ",
  #            "   WHERE ome00 = '1' AND ome22 = 'Y' ",
  #            "     AND rtrim(omexml) = '",p_filename,"' ",
  #            "     AND omevoid = 'Y' AND omecncl = 'N' "
  #PREPARE p210_prepare5 FROM g_sql
  #DECLARE p210_cs5 CURSOR FOR p210_prepare5
  #EXECUTE p210_cs5 INTO l_n 
  #IF l_n = 0 OR cl_null(l_n) THEN
  #   RETURN
  #END IF
  #LET g_sql = " SELECT * FROM ome_file ",
  #            "   WHERE ome00 = '1' AND ome22 = 'Y' ",
  #            "     AND rtrim(omexml) = '",p_filename,"' ",
  #            "     AND omevoid = 'Y' AND omecncl = 'N' "
  #PREPARE p210_prepare6 FROM g_sql
  #DECLARE p210_cs6 CURSOR FOR p210_prepare6
  #FUN-C80002 mark END
   LET p_filename = "C0501-",p_filename
   LET p_filename = p_filename,".xml"
   IF g_bgjob = 'N' THEN
      LET l_filename = fgl_getenv("TEMPDIR"), "/",p_filename
   ELSE
      LET l_filename = g_path,p_filename
   END IF
   LET lc_channe1 = base.Channel.create()
   CALL lc_channe1.openFile(l_filename,"w")
   IF STATUS THEN
      LET g_success = 'N'
      RETURN
   END IF
   CALL lc_channe1.setDelimiter("")
   LET ms_codeset = cl_get_codeset()
   LET l_str = '<?xml version="1.0" encoding="UTF-8"?>'
   CALL lc_channe1.write(l_str)
  #FUN-C80002 add START
   LET l_str = '<CancelInvoice xsi:schemaLocation="urn:GEINV:eInvoiceMessage:C0501:3.0 C0501.xsd" xmlns="urn:GEINV:eInvoiceMessage:C0501:3.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
   CALL lc_channe1.write(l_str)
  #FUN-C80002 add END
  #FOREACH p210_cs6 INTO l_ome.*    #FUN-C80002 mark
      CALL p210_train(10,l_ome.ome01) RETURNING l_ome.ome01
     #LET l_ome02 = l_ome.ome02 USING 'yyyymmdd'   #FUN-C80038 mark
      LET l_ome02 = l_ome.ome02 USING 'YYYY-MM-DD'  #FUN-C80038 add
      CALL p210_train(10,l_ome.ome042) RETURNING l_ome.ome042
      IF cl_null(l_ome.ome042) THEN LET l_ome.ome042 = '0000000000' END IF   #FUN-C80038 add
      CALL p210_train(10,l_ome.ome60) RETURNING l_ome.ome60
     #LET l_omevoidd = l_ome.omevoidd USING 'yyyymmdd'      #FUN-C80038 mark 
      LET l_omevoidd = l_ome.omevoidd USING 'YYYY-MM-DD'    #FUN-C80038 add
      SELECT azf03 INTO l_azf03 FROM azf_file 
        WHERE azf01=l_ome.omevoid2 AND azf02='2'
      CALL p210_train(20,l_azf03) RETURNING l_azf03
      CALL p210_train(60,l_ome.omevoidn) RETURNING l_ome.omevoidn
      CALL p210_train(200,l_ome.omevoidm) RETURNING l_ome.omevoidm
    
     #LET l_str = '<CancelInvoice>'          #FUN-C80002 mark
     #CALL lc_channe1.write(l_str)           #FUN-C80002 mark
      LET l_str = "        <CancelInvoiceNumber>",l_ome.ome01 CLIPPED,"</CancelInvoiceNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <InvoiceDate>",l_ome02 CLIPPED,"</InvoiceDate>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <BuyerId>",l_ome.ome042 CLIPPED,"</BuyerId>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <SellerId>",l_ome.ome60 CLIPPED,"</SellerId>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <CancelDate>",l_omevoidd CLIPPED,"</CancelDate>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <CancelTime>",l_ome.omevoidt CLIPPED,"</CancelTime>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <CancelReason>",l_azf03 CLIPPED,"</CancelReason>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <ReturnTaxDocumentNumber>",l_ome.omevoidn CLIPPED,"</ReturnTaxDocumentNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <Remark>",l_ome.omevoidm CLIPPED,"</Remark>"
      CALL lc_channe1.write(l_str)
      LET l_str = '</CancelInvoice>'
      CALL lc_channe1.write(l_str)
  #END FOREACH    #FUN-C80002 mark
   CALL lc_channe1.close()
   LET g_path = g_path.toLowerCase( )
   LET g_path = g_path.trim()
   LET window_path = g_path,p_filename

   IF g_bgjob = 'N' THEN
      LET status = cl_download_file(l_filename, window_path)
      IF status then
        #CALL cl_err(p_filename,"amd-040",1)    #FUN-C80002 mark
         DISPLAY "Download OK!!"
      ELSE
        #CALL cl_err(p_filename,"amd-041",1)    #FUN-C80002 mark
         DISPLAY "Download fail!!"
         LET g_success = 'N'
      END IF

      LET l_cmd = "rm ",l_filename CLIPPED," 2>/dev/null"
      DISPLAY l_cmd
      RUN l_cmd
      LET l_cmd = "rm ",l_filename CLIPPED," 2>/dev/null"
      DISPLAY l_cmd
      RUN l_cmd
   END IF
END FUNCTION

#FUNCTION p210_xml3(p_filename)   #產生C0701 xml  #FUN-C80002 mark
FUNCTION p210_xml3(p_filename,l_ome)   #FUN-C80002 add
DEFINE l_ome           RECORD LIKE ome_file.*
DEFINE l_n                 LIKE type_file.num5
DEFINE p_filename          STRING
DEFINE l_filename          STRING
DEFINE l_cmd               STRING
DEFINE l_str               STRING
DEFINE ms_codeset          STRING
DEFINE lc_channe1          base.Channel
DEFINE window_path         STRING
DEFINE l_ome02             STRING
DEFINE l_omecncld          STRING
DEFINE l_azf03             LIKE azf_file.azf03

  #FUN-C80002 mark START
  #LET g_sql = " SELECT COUNT(*) FROM ome_file ",
  #            "   WHERE ome00 = '1' AND ome22 = 'Y' ",
  #            "     AND rtrim(omexml) = '",p_filename,"' ",
  #            "     AND omevoid = 'N' AND omecncl = 'Y' "
  #PREPARE p210_prepare7 FROM g_sql
  #DECLARE p210_cs7 CURSOR FOR p210_prepare7
  #EXECUTE p210_cs7 INTO l_n 
  #IF l_n = 0 OR cl_null(l_n) THEN
  #   RETURN
  #END IF
  #LET g_sql = " SELECT * FROM ome_file ",
  #            "   WHERE ome00 = '1' AND ome22 = 'Y' ",
  #            "     AND rtrim(omexml) = '",p_filename,"' ",
  #            "     AND omevoid = 'N' AND omecncl = 'Y' "
  #PREPARE p210_prepare8 FROM g_sql
  #DECLARE p210_cs8 CURSOR FOR p210_prepare8
  #FUN-C80002 mark END
   LET p_filename = "C0701-",p_filename
   LET p_filename = p_filename,".xml"
   IF g_bgjob = 'N' THEN
      LET l_filename = fgl_getenv("TEMPDIR"), "/",p_filename
   ELSE
      LET l_filename = g_path,p_filename
   END IF
   LET lc_channe1 = base.Channel.create()
   CALL lc_channe1.openFile(l_filename,"w")
   IF STATUS THEN
      LET g_success = 'N'
      RETURN
   END IF
   CALL lc_channe1.setDelimiter("")
   LET ms_codeset = cl_get_codeset()
   LET l_str = '<?xml version="1.0" encoding="UTF-8"?>'
   CALL lc_channe1.write(l_str)
  #FUN-C80002 add START
   LET l_str = '<VoidInvoice xsi:schemaLocation="urn:GEINV:eInvoiceMessage:C0701:3.0 C0701.xsd" xmlns="urn:GEINV:eInvoiceMessage:C0701:3.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
   CALL lc_channe1.write(l_str)
  #FUN-C80002 add END
  #FOREACH p210_cs8 INTO l_ome.*    #FUN-C80002 mark
      CALL p210_train(10,l_ome.ome01) RETURNING l_ome.ome01
     #LET l_ome02 = l_ome.ome02 USING 'yyyymmdd'      #FUN-C80038 mark
      LET l_ome02 = l_ome.ome02 USING 'YYYY-MM-DD'    #FUN-C80038 add
      CALL p210_train(10,l_ome.ome042) RETURNING l_ome.ome042
      IF cl_null(l_ome.ome042) THEN LET l_ome.ome042 = '0000000000' END IF   #FUN-C80038 add
      CALL p210_train(10,l_ome.ome60) RETURNING l_ome.ome60
     #LET l_omecncld = l_ome.omecncld USING 'yyyymmdd'   #FUN-C80038 mark 
      LET l_omecncld = l_ome.omecncld USING 'YYYY-MM-DD'   #FUN-C80038 add
      SELECT azf03 INTO l_azf03 FROM azf_file
        WHERE azf01=l_ome.omecncl2 AND azf02='2'
      CALL p210_train(20,l_azf03) RETURNING l_azf03
      CALL p210_train(200,l_ome.omecnclm) RETURNING l_ome.omecnclm

     #LET l_str = '<VoidInvoice>'     #FUN-C80002 mark
     #CALL lc_channe1.write(l_str)    #FUN-C80002 mark 
      LET l_str = "        <VoidInvoiceNumber>",l_ome.ome01 CLIPPED,"</VoidInvoiceNumber>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <InvoiceDate>",l_ome02 CLIPPED,"</InvoiceDate>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <BuyerId>",l_ome.ome042 CLIPPED,"</BuyerId>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <SellerId>",l_ome.ome60 CLIPPED,"</SellerId>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <VoidDate>",l_omecncld CLIPPED,"</VoidDate>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <VoidTime>",l_ome.omecnclt CLIPPED,"</VoidTime>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <VoidReason>",l_azf03 CLIPPED,"</VoidReason>"
      CALL lc_channe1.write(l_str)
      LET l_str = "        <Remark>",l_ome.omecnclm CLIPPED,"</Remark>"
      CALL lc_channe1.write(l_str)
      LET l_str = '</VoidInvoice>'
      CALL lc_channe1.write(l_str)
  #END FOREACH    #FUN-C80002 mark 
   CALL lc_channe1.close()
   LET g_path = g_path.toLowerCase( )
   LET g_path = g_path.trim()
   LET window_path = g_path,p_filename

   IF g_bgjob = 'N' THEN
      LET status = cl_download_file(l_filename, window_path)
      IF status then
        #CALL cl_err(p_filename,"amd-040",1)   #FUN-C80002 mark
         DISPLAY "Download OK!!"
      ELSE
        #CALL cl_err(p_filename,"amd-041",1)   #FUN-C80002 mark
         DISPLAY "Download fail!!"
         LET g_success = 'N'
      END IF

      LET l_cmd = "rm ",l_filename CLIPPED," 2>/dev/null"
      DISPLAY l_cmd
      RUN l_cmd
      LET l_cmd = "rm ",l_filename CLIPPED," 2>/dev/null"
      DISPLAY l_cmd
      RUN l_cmd
   END IF
END FUNCTION

FUNCTION p210_train(l_n,p_str)
DEFINE l_n          LIKE type_file.num5
DEFINE p_str        STRING
DEFINE l_length     LIKE type_file.num5
DEFINE l_sp         LIKE type_file.num5
DEFINE l_str1       STRING
DEFINE l_i          LIKE type_file.num5
DEFINE l_n2         LIKE type_file.num5
    LET l_length = p_str.getLength()   #總長度
    IF l_length > l_n THEN
       LET p_str = p_str.subString(1,l_n)
       LET l_length = l_n
    END IF
    LET p_str = p_str CLIPPED
    LET p_str = p_str.trim()
    RETURN p_str
END FUNCTION

#數字轉文字
#數值固定最多取到小數點後4位數
FUNCTION p210_train2(l_num)
DEFINE l_n          LIKE type_file.num5
DEFINE l_num        LIKE type_file.num20_6
DEFINE l_int        LIKE type_file.num20 
DEFINE l_int_str    STRING
DEFINE l_int2       LIKE type_file.num5
DEFINE l_int2_str   STRING
DEFINE l_str        STRING
DEFINE l_fillin     STRING
DEFINE l_a          LIKE type_file.num5
DEFINE l_dot_length LIKE type_file.num5
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_length     LIKE type_file.num5
DEFINE l_length2    LIKE type_file.num5
DEFINE l_sp         LIKE type_file.num5
DEFINE l_i          LIKE type_file.num5
   
 
    LET l_fillin = l_num 
    LET l_a = l_fillin.getIndexOf('.',1)  #小數點所在位置
    LET l_int = l_fillin.subString(1,l_a-1)        #整數
    LET l_int2 = l_fillin.subString(l_a+1,l_a+4)   #小數值
    LET l_int2_str = l_int2 USING "&&&&"
    LET l_i = 4
    WHILE TRUE
       IF l_int2_str.subString(l_i,l_i) = 0  THEN
          LET l_int2_str = l_int2_str.subString(1,l_i-1)
       ELSE
          EXIT WHILE
       END IF
       LET l_i = l_i - 1
       IF l_i = 0 THEN
          EXIT WHILE
       END IF  
    END WHILE
    LET l_int_str = l_int
    LET l_int_str = l_int_str.trim()
    LET l_int2_str = l_int2_str.trim()
    IF l_int = 0  THEN
       IF l_int2 = 0 THEN
          LET l_str = "0"
       ELSE
          LET l_str =  "0.",l_int2_str.trim()
       END IF
    ELSE
       IF l_int2 = 0 THEN
          LET l_str = l_int_str.trim()
       ELSE
          LET l_str = l_int_str.trim() ,".",l_int2_str.trim()  
       END IF
    END IF
    LET l_str = l_str CLIPPED
    RETURN l_str
END FUNCTION

#FUN-C70030

#FUN-C80002 add START
#取得filename流水號
FUNCTION p210_filename2(p_type)
 DEFINE p_type             LIKE type_file.chr1     #1:匯出C0401 2:匯出C0501  3:匯出C0701 
 DEFINE l_sql              STRING
 DEFINE l_wc               STRING
 DEFINE l_filename         LIKE ome_file.omexml
 DEFINE l_time             LIKE ome_file.omevoidt
 DEFINE l_n                LIKE type_file.num20   
 DEFINE l_omexml           LIKE ome_file.omexml
 DEFINE l_omexml_str       STRING 

   LET l_filename = g_filename CLIPPED
   LET l_wc = " 1=1"
   LET l_omexml =  ' '
   LET l_omexml_str = ' '

   LET l_sql = " SELECT MAX(omexml) FROM ome_file ",
               "   WHERE omexml LIKE '%",l_filename,"%'",
               "     AND ome00 = '1' ",
               "     AND ome22 = 'Y' ",
               "     AND ",l_wc
   PREPARE p210_prepare FROM l_sql
   DECLARE p210_cs CURSOR FOR p210_prepare
   EXECUTE p210_cs INTO l_omexml  
   LET l_omexml_str = l_omexml
   IF cl_null(l_omexml) THEN
      LET l_omexml = g_filename CLIPPED,"000001"
      RETURN l_omexml
   END IF
   IF l_omexml_str.subString(15,20) = '999999' THEN
      LET l_omexml = ' '
      RETURN ' '
   ELSE
      LET l_omexml = l_omexml + 1 
   END IF
   
   RETURN l_omexml 
END FUNCTION
#取得filename的前半部名稱
FUNCTION p210_filename1()
 DEFINE l_filename         LIKE ome_file.omexml
 DEFINE l_time             LIKE ome_file.omevoidt

   LET g_success = 'Y'
   LET l_filename = TODAY USING "yyyymmdd"
   LET l_time = TIME
   LET l_time = cl_replace_str(l_time,":","")
   LET l_filename = l_filename CLIPPED ,l_time CLIPPED
   LET g_filename = l_filename    
END FUNCTION

FUNCTION p210_get_ome()
   #將要匯出的發票資料鎖住,避免相同發票重覆匯出
   BEGIN WORK
   UPDATE ome_file SET ome81 = 3
           WHERE (omexml IS NULL OR omexml = ' ' )
             AND ome22 = 'Y'
             AND ome00 = '1'
             AND ome81 NOT IN ('3')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","ome_file",'',"",SQLCA.sqlcode,"","upd omexml",1)
      ROLLBACK WORK
      LET g_success = 'N'
   ELSE
      COMMIT WORK
   END IF

   #一張發票一個transaction,避免時間差匯出相同filename的問題,將時間差降到最低
   #因為會各自commit work ,所以要將匯出的發票資料放於array中,因為用foreach時commit work會自動將cursor關閉
   CALL g_ome.clear()
   LET g_idx = 1
   LET g_sql = " SELECT DISTINCT * FROM ome_file ",
               " WHERE ome81 = '3' "
   PREPARE p210_prepare2 FROM g_sql
   DECLARE p210_cs2 CURSOR FOR p210_prepare2
   FOREACH p210_cs2 INTO g_ome[g_idx].*
      LET g_idx = g_idx + 1
   END FOREACH
   LET g_idx = g_idx - 1
 
END FUNCTION
#FUN-C80002 add END

