# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: s_tlff2.4gl
# Descriptions...: 將異動資料放入異動記錄檔中(製造管理)
# Date & Author..: 05/08/09 By Carrier
# Usage..........: CALL s_tlff2(p_flag,p_unit,p_dbs)
# Input Parameter: p_flag     1.第一單位 2.第二單位 
#                  p_unit     母單位
#                  p_pdbs     數據庫
# Return Code....: None
# Modify.........: NO.FUN-670091 06/07/25 BY yiting cl_err=>cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: NO.CHI-730005 07/07/20 BY yiting INSERT INTO tlff_file有誤
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950034 09/05/08 By mike 將跨資料庫查詢使用 ":" 改為 s_dbstring() 作法
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980059 09/09/11 By arman GP5.2架構 修改SUB傳入參數 
# Modify.........: No.FUN-980094 09/09/17 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No:FUN-9B0149 09/11/30 By kim add tlff27
# Modify.........: No:TQC-9C0059 09/12/09 By sherry 重新過單
# Modify.........: No:FUN-A60028 10/06/24 By lilingyu 平行工藝
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70125 10/07/26 By lilingyu 平行工藝整批處理
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.MOD-C10089 12/01/10 By suncx g_plant賦值錯誤

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_chr           LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose 	#No.FUN-680147 SMALLINT
DEFINE   g_db            LIKE azp_file.azp03
DEFINE   g_plant         LIKE azp_file.azp01     #No.FUN-980059
#FUNCTION s_tlff2(p_flag,p_unit,p_dbs)  #No.FUN-980059
FUNCTION s_tlff2(p_flag,p_unit,p_plant) #No.FUN-980059
    DEFINE
        p_flag          LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
        p_unit          LIKE ima_file.ima25,
        p_dbs           LIKE azp_file.azp03,
        p_dbs_tra       LIKE azp_file.azp03,#No.FUN-980059
        p_plant         LIKE azp_file.azp03,    #No.FUN-980059
        l_cnt           LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_reason        LIKE apo_file.apo02, 	#No.FUN-680147 VARCHAR(04)
        l_sql           LIKE type_file.chr1000,	#No.FUN-680147 VARCHAR(1000)
        s_f             LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        g_ima25         LIKE ima_file.ima25,
        l_ima906        LIKE ima_file.ima906,
        l_ima907        LIKE ima_file.ima907,
        l_rowid         LIKE type_file.row_id,  #chr18, FUN-A70120
        l_flag          LIKE type_file.chr1,  	#No.FUN-680147 VARCHAR(1)
        l_legal         LIKE tlff_file.tlfflegal       #FUN-980094
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    ##NO.FUN-980059 GP5.2 add begin
    #IF cl_null(p_plant) THEN   #FUN-A50102
    #  LET p_dbs = NULL
    #ELSE
    #  LET g_plant_new = p_plant
    #  CALL s_getdbs()
    #  LET p_dbs= g_dbs_new
    #  CALL s_gettrandbs()
    #  LET p_dbs_tra = g_dbs_tra
    #END IF
    ##NO.FUN-980059 GP5.2 add end
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( g_tlff.tlff01 ,p_plant) OR NOT s_internal_item( g_tlff.tlff01,p_plant ) THEN
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
    IF g_tlff.tlff021 IS NULL THEN LET g_tlff.tlff021=' ' END IF
    IF g_tlff.tlff022 IS NULL THEN LET g_tlff.tlff022=' ' END IF
    IF g_tlff.tlff023 IS NULL THEN LET g_tlff.tlff023=' ' END IF
    IF g_tlff.tlff031 IS NULL THEN LET g_tlff.tlff031=' ' END IF
    IF g_tlff.tlff032 IS NULL THEN LET g_tlff.tlff032=' ' END IF
    IF g_tlff.tlff033 IS NULL THEN LET g_tlff.tlff033=' ' END IF
    IF g_tlff.tlff027 IS NULL THEN LET g_tlff.tlff027 = 0 END IF
    IF g_tlff.tlff037 IS NULL THEN LET g_tlff.tlff037 = 0 END IF
 
#FUN-A60028 --begin--
   IF cl_null(g_tlff.tlff012) THEN LET g_tlff.tlff012 = ' ' END IF 
   IF cl_null(g_tlff.tlff013) THEN LET g_tlff.tlff013 = 0 END IF 
#FUN-A60028 --end--
 
    LET g_tlff.tlff07 = TODAY
    LET g_tlff.tlff08 = TIME  
    IF g_tlff.tlff13 = 'aimp880' THEN LET g_tlff.tlff08='99:99:99' END IF
    IF cl_null(g_tlff.tlff12) THEN LET g_tlff.tlff12=1 END IF 
    IF cl_null(g_tlff.tlff026) THEN LET g_tlff.tlff026 = g_tlff.tlff036 END IF 
    IF cl_null(g_tlff.tlff036) THEN LET g_tlff.tlff036 = g_tlff.tlff026 END IF 
    IF g_tlff.tlff05 IS NULL THEN LET g_tlff.tlff05 =' ' END IF
 
    #------ 97/06/23
    LET g_tlff.tlff905='' #No:5416
    LET g_tlff.tlff906=0    
    LET g_tlff.tlff907=0
    LET g_tlff.tlff211=''
    LET g_tlff.tlff220=g_tlff.tlff11  #FUN-540024
    IF g_tlff.tlff02=50 AND g_tlff.tlff03=50 THEN
       PROMPT "來源與目的不可均為50:" FOR CHAR g_chr
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
       END PROMPT
       LET g_success='N' RETURN
    END IF
    IF g_tlff.tlff02=50 THEN                ##--- 出庫
       LET g_tlff.tlff902=g_tlff.tlff021
       LET g_tlff.tlff903=g_tlff.tlff022
       LET g_tlff.tlff904=g_tlff.tlff023
       LET g_tlff.tlff905=g_tlff.tlff026
       LET g_tlff.tlff906=g_tlff.tlff027
       LET g_tlff.tlff907=-1             
    END IF
    IF g_tlff.tlff03=50 THEN                ##--- 入庫
       LET g_tlff.tlff902=g_tlff.tlff031
       LET g_tlff.tlff903=g_tlff.tlff032
       LET g_tlff.tlff904=g_tlff.tlff033
       LET g_tlff.tlff905=g_tlff.tlff036
       LET g_tlff.tlff906=g_tlff.tlff037
       LET g_tlff.tlff907=1             
    END IF 
    ##--- 收貨不影響庫存,但仍應給 tlff90*的值
    IF g_tlff.tlff13='apmt1101' OR g_tlff.tlff13='asft6001' THEN   
       LET g_tlff.tlff902=g_tlff.tlff031
       LET g_tlff.tlff903=g_tlff.tlff032
       LET g_tlff.tlff904=g_tlff.tlff033
       LET g_tlff.tlff905=g_tlff.tlff036
       LET g_tlff.tlff906=g_tlff.tlff037
       LET g_tlff.tlff907=0             
    END IF
    LET g_tlff.tlff61=g_tlff.tlff905[1,g_doc_len]		#971028 Roger  #FUN-560043
    LET g_db = s_madd_img_catstr(p_dbs)
   #LET g_plant = s_madd_img_catstr(p_plant)     #No.FUN-980059
    LET g_plant = p_plant    #MOD-C10089 
    #--------------------------------------------------------------------------
     #MOD-4C0053(ADD IF...END IF)
    IF NOT cl_null(g_tlff.tlff902) THEN
       #LET l_sql = "SELECT imd09 FROM ",p_dbs CLIPPED,".imd_file ", #TQC-950034  
        #LET l_sql = "SELECT imd09 FROM ",s_dbstring(p_dbs CLIPPED),"imd_file ", #TQC-950034
        LET l_sql = "SELECT imd09 FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
                    " WHERE imd01='",g_tlff.tlff902 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE imd_cur FROM l_sql
        DECLARE imd_curs CURSOR FOR imd_cur
        OPEN imd_curs
        FETCH imd_curs INTO g_tlff.tlff901
        IF STATUS
           THEN
           #CALL cl_err('sel imd_file','mfg9040',1)  #FUN-670091
            CALL cl_err3("sel","imd_file",g_tlff.tlff902,"",STATUS,"","",0)  #FUN-670091
           LET g_success='N' RETURN
        END IF
    END IF
   #LET l_sql="SELECT ima25,ima906,ima907 FROM ",p_dbs CLIPPED,".ima_file", #TQC-950034 
    #LET l_sql="SELECT ima25,ima906,ima907 FROM ",s_dbstring(p_dbs CLIPPED),"ima_file", #TQC-950034
    LET l_sql="SELECT ima25,ima906,ima907 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102
              " WHERE ima01='",g_tlff.tlff01,"' AND imaacti='Y'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE ima_cur FROM l_sql
    EXECUTE ima_cur INTO g_ima25,l_ima906,l_ima907
    IF STATUS THEN
       #CALL cl_err('sel ima_file',STATUS,1)  #FUN-670091
        CALL cl_err3("sel","ima_file",g_tlff.tlff01,"",STATUS,"","",1)  #FUN-670091
       LET g_success='N' RETURN
    END IF
 #  CALL s_umfchk1(g_tlff.tlff01,g_tlff.tlff11,g_ima25,g_db)     #No.FUN-980059
    CALL s_umfchk1(g_tlff.tlff01,g_tlff.tlff11,g_ima25,g_plant)  #No.FUN-980059
      RETURNING l_flag,g_tlff.tlff60
    IF l_flag AND NOT (l_ima906 = '3' AND p_flag = '2') THEN
       CALL cl_err('','abm-731',1)
       LET g_success='N'
       LET g_tlff.tlff60=1.0
    END IF
    IF STATUS OR g_tlff.tlff60 IS NULL THEN LET g_tlff.tlff60=1 END IF
    #--------------------------------------------------------------------------
    IF (g_tlff.tlff02=50 OR g_tlff.tlff03=50) AND g_tlff.tlff13<>'aimp880' THEN
      #IF NOT s_chksmz1(g_tlff.tlff01,g_tlff.tlff905[1,g_doc_len],g_tlff.tlff902,g_tlff.tlff903,g_db)
       IF NOT s_chksmz1(g_tlff.tlff01,g_tlff.tlff905[1,g_doc_len],g_tlff.tlff902,g_tlff.tlff903,g_plant)  #FUN-980094
          THEN LET g_success='N' RETURN
       END IF
    END IF
    #--------------------------------------------------------------------------
## 為了避免同一筆單據多人(sessoin)同時過帳造成 重複update img_file
## and insert tlff_file 
   #No.B627 委外採購入庫所產生之發料單時若分批入庫會重複,故必須加上目的單號
   IF p_flag = '1' THEN LET g_tlff.tlff219=2 END IF
   IF p_flag = '2' THEN LET g_tlff.tlff219=1 END IF
   IF p_flag = '1' THEN
      IF g_tlff.tlff902 IS NOT NULL OR g_tlff.tlff903 IS NOT NULL OR
         g_tlff.tlff904 IS NOT NULL THEN
        #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,".tlff_file", #TQC-950034  
        #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs CLIPPED),"tlff_file",#TQC-950034 
         #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs_tra CLIPPED),"tlff_file",#FUN-980094
         LET l_sql="SELECT rowid FROM ",cl_get_target_table(p_plant,'tlff_file'), #FUN-A50102
                   " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                   "   AND tlff02 =  ",g_tlff.tlff02 ,
                   "   AND tlff03 =  ",g_tlff.tlff03 ,
                   "   AND tlff902= '",g_tlff.tlff902,"'",
                   "   AND tlff903= '",g_tlff.tlff903,"'",
                   "   AND tlff904= '",g_tlff.tlff904,"'",
                   "   AND tlff905= '",g_tlff.tlff905,"'",
                   "   AND tlff906=  ",g_tlff.tlff906,
                   "   AND tlff907=  ",g_tlff.tlff907,
                   "   AND tlff220= '",p_unit,"'"   #尋找母單位的rowid
                  ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                  ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                     
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
         PREPARE tlff_cur1 FROM l_sql
         EXECUTE tlff_cur1 INTO l_rowid
      ELSE   
         IF NOT cl_null(g_tlff.tlff021) THEN
           #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,".tlff_file",#TQC-950034 
           #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs CLIPPED),"tlff_file", #TQC-950034  
            #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs_tra CLIPPED),"tlff_file", #FUN-980094 
           LET l_sql="SELECT rowid FROM ",cl_get_target_table(p_plant,'tlff_file'), #FUN-A50102
                      " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                      "   AND tlff02 =  ",g_tlff.tlff02 ,
                      "   AND tlff03 =  ",g_tlff.tlff03 ,
                      "   AND tlff021= '",g_tlff.tlff021,"'",
                      "   AND tlff022= '",g_tlff.tlff022,"'",
                      "   AND tlff023= '",g_tlff.tlff023,"'",
                      "   AND tlff026= '",g_tlff.tlff026,"'",
                      "   AND tlff027=  ",g_tlff.tlff027,
                      "   AND tlff220= '",p_unit,"'"   #尋找母單位的rowid
                     ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                     ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                        
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
            PREPARE tlff_cur2 FROM l_sql
            EXECUTE tlff_cur2 INTO l_rowid
         END IF
         IF NOT cl_null(g_tlff.tlff031) THEN
           #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,".tlff_file",  #TQC-950034     
           #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs CLIPPED),"tlff_file",  #TQC-950034   
            #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs_tra CLIPPED),"tlff_file",  #FUN-980094
           LET l_sql="SELECT rowid FROM ",cl_get_target_table(p_plant,'tlff_file'), #FUN-A50102   
                      " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                      "   AND tlff02 =  ",g_tlff.tlff02 ,
                      "   AND tlff03 =  ",g_tlff.tlff03 ,
                      "   AND tlff031= '",g_tlff.tlff031,"'",
                      "   AND tlff032= '",g_tlff.tlff032,"'",
                      "   AND tlff033= '",g_tlff.tlff033,"'",
                      "   AND tlff036= '",g_tlff.tlff036,"'",
                      "   AND tlff037=  ",g_tlff.tlff037,
                      "   AND tlff220= '",p_unit,"'"   #尋找母單位的rowid
                     ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                     ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                        
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
            PREPARE tlff_cur3 FROM l_sql
            EXECUTE tlff_cur3 INTO l_rowid
         END IF
      END IF
      IF STATUS THEN
         IF NOT cl_null(p_unit) THEN
            #CALL cl_err('(s_tlff:select parent rowid)',STATUS,1)  #FUN-670091
             CALL cl_err3("sel","tlff_file",g_tlff.tlff01,"",STATUS,"","s_tlff:select parent rowid",1)   #FUN-670091
            LET g_success='N' RETURN
         ELSE
            LET p_flag='2'
         END IF
      ELSE
         LET g_tlff.tlff218 = l_rowid
      END IF
   END IF
   #FUN-540024  --end
#######
 
    CALL s_getlegal(p_plant) RETURNING l_legal
    LET g_tlff.tlffplant = p_plant  #FUN-980012 add 
    LET g_tlff.tlfflegal = l_legal  #FUN-980012 add 

#FUN-A70125 --begin--
      IF cl_null(g_tlff.tlff012) THEN
         LET g_tlff.tlff012 = ' '
      END IF
      IF cl_null(g_tlff.tlff013) THEN
        LET g_tlff.tlff013 = 0
      END IF
#FUN-A70125 --end--
 
   #LET l_sql = "INSERT INTO ",p_dbs CLIPPED,".tlff_file", #TQC-950034
   #LET l_sql = "INSERT INTO ",s_dbstring(p_dbs CLIPPED),"tlff_file", #TQC-950034     
    #LET l_sql = "INSERT INTO ",s_dbstring(p_dbs_tra CLIPPED),"tlff_file", #FUN-980094 
    LET l_sql = "INSERT INTO ",cl_get_target_table(p_plant,'tlff_file'), #FUN-A50102 
   {ckp#1}      " VALUES(?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?)"    #FUN-980012 add 2 ??  #FUN-9B0149  #FUN-A60028 add ? ? 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE tlff_ins FROM l_sql
    EXECUTE tlff_ins USING g_tlff.*
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       #CALL cl_err('(s_tlff2:ckp#1)',SQLCA.sqlcode,1)  #FUN-670091
        CALL cl_err3("ins","tlff_file","","",STATUS,"","",1)  #FUN-670091
       RETURN
    END IF
 
    IF p_flag = '2' THEN
       IF g_tlff.tlff902 IS NOT NULL OR g_tlff.tlff903 IS NOT NULL OR
          g_tlff.tlff904 IS NOT NULL THEN
         #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,".tlff_file", #TQC-950034
         #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs CLIPPED),"tlff_file", #TQC-950034 
          #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs_tra CLIPPED),"tlff_file", #FUN-980094 
          LET l_sql="SELECT rowid FROM ",cl_get_target_table(p_plant,'tlff_file'), #FUN-A50102
                    " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                    "   AND tlff02 =  ",g_tlff.tlff02 ,
                    "   AND tlff03 =  ",g_tlff.tlff03 ,
                    "   AND tlff902= '",g_tlff.tlff902,"'",
                    "   AND tlff903= '",g_tlff.tlff903,"'",
                    "   AND tlff904= '",g_tlff.tlff904,"'",
                    "   AND tlff905= '",g_tlff.tlff905,"'",
                    "   AND tlff906=  ",g_tlff.tlff906,
                    "   AND tlff907=  ",g_tlff.tlff907,
                    "   AND tlff220= '",g_tlff.tlff220,"'"   #尋找母單位的rowid
                   ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                   ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
          PREPARE tlff_cur4 FROM l_sql
          EXECUTE tlff_cur4 INTO l_rowid
        ELSE
          IF NOT cl_null(g_tlff.tlff021) THEN
            #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,".tlff_file", #TQC-950034  
            #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs CLIPPED),"tlff_file", #TQC-950034     
             #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs_tra CLIPPED),"tlff_file", #FUN-980094
            LET l_sql="SELECT rowid FROM ",cl_get_target_table(p_plant,'tlff_file'), #FUN-A50102   
                       " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                       "   AND tlff02 =  ",g_tlff.tlff02 ,
                       "   AND tlff03 =  ",g_tlff.tlff03 ,
                       "   AND tlff021= '",g_tlff.tlff021,"'",
                       "   AND tlff022= '",g_tlff.tlff022,"'",
                       "   AND tlff023= '",g_tlff.tlff023,"'",
                       "   AND tlff026= '",g_tlff.tlff026,"'",
                       "   AND tlff027=  ",g_tlff.tlff027,
                       "   AND tlff220= '",g_tlff.tlff220,"'"   #尋找母單位的rowid
                      ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                      ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                         
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
             PREPARE tlff_cur5 FROM l_sql
             EXECUTE tlff_cur5 INTO l_rowid
          END IF
          IF NOT cl_null(g_tlff.tlff031) THEN
            #LET l_sql="SELECT rowid FROM ",p_dbs CLIPPED,".tlff_file", #TQC-950034
            #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs CLIPPED),"tlff_file", #TQC-950034       
             #LET l_sql="SELECT rowid FROM ",s_dbstring(p_dbs_tra CLIPPED),"tlff_file", #FUN-980094
            LET l_sql="SELECT rowid FROM ",cl_get_target_table(p_plant,'tlff_file'), #FUN-A50102        
                       " WHERE tlff01 = '",g_tlff.tlff01 ,"'",
                       "   AND tlff02 =  ",g_tlff.tlff02 ,
                       "   AND tlff03 =  ",g_tlff.tlff03 ,
                       "   AND tlff031= '",g_tlff.tlff031,"'",
                       "   AND tlff032= '",g_tlff.tlff032,"'",
                       "   AND tlff033= '",g_tlff.tlff033,"'",
                       "   AND tlff036= '",g_tlff.tlff036,"'",
                       "   AND tlff037=  ",g_tlff.tlff037,
                       "   AND tlff220= '",g_tlff.tlff220,"'"   #尋找母單位的rowid
                      ,"   AND tlff012= '",g_tlff.tlff012,"'"                    #FUN-A60028
                      ,"   AND tlff013= '",g_tlff.tlff013,"'"                    #FUN-A60028                         
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
             PREPARE tlff_cur6 FROM l_sql
             EXECUTE tlff_cur6 INTO l_rowid
          END IF
       END IF
       IF STATUS THEN
          #CALL cl_err('(s_tlff:select rowid)',STATUS,1) #FUN-670091
          CALL cl_err3("sel","tlff_file","","",STATUS,"","s_tlff:select rowid",1) #FUN-670091  
          LET g_success='N' RETURN
       ELSE
          LET g_tlff.tlff218 = l_rowid
         #LET l_sql="UPDATE ",p_dbs CLIPPED,".tlff_file", #TQC-950034 
         #LET l_sql="UPDATE ",s_dbstring(p_dbs CLIPPED),"tlff_file", #TQC-950034    
          #LET l_sql="UPDATE ",s_dbstring(p_dbs_tra CLIPPED),"tlff_file", #FUN-980094
        LET l_sql="UPDATE ",cl_get_target_table(p_plant,'tlff_file'), #FUN-A50102  
                    "   SET tlff218='",g_tlff.tlff218,"'",
                    " WHERE rowid='",l_rowid,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
          PREPARE tlff_cur7 FROM l_sql
          EXECUTE tlff_cur7
          IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
             #CALL cl_err('(s_tlff:update tlff218)',STATUS,1)       #FUN-670091
              CALL cl_err3("upd","tlff_file","","",STATUS,"","",1)  #FUN-670091
             LET g_success ='N' RETURN
          END IF
       END IF
    END IF
    #FUN-540024  --end
    #--------------------------------------------------------------------------
END FUNCTION
#TQC-9C0059 
