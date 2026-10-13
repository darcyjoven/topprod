/*
================================================================================
檔案代號:zz_file
檔案名稱:程序资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zz_file
(
zz01        varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*程式代號, (program code)               */
                                     /* Ex:pka0203 , pkb0218                  */
zz02        varchar2(80),            /*No Use                                 */
                                     /*程式名稱                               */
zz02e       varchar2(40),            /*No Use                                 */
                                     /*程式英文名稱                           */
zz02c       varchar2(40),            /*No Use                                 */
                                     /*簡體中文名稱                           */
zz03        varchar2(1),             /*程序类型                               */
                                     /*程式類別                               */
                                     /*  M:目錄程式類(Menu)                   */
                                     /*  F:建檔程式類(Form)                   */
                                     /*  T:異動程式類(Transaction)            */
                                     /*  P:處理程式類(Process)                */
                                     /*  R:報表程式類(Report)                 */
zz04        varchar2(3000),          /*基本提供运行功能                       */
                                     /*基本提供執行功能                       */
                                     /*本程式所提供之基本執行功能             */
                                     /*Ex:AQURCOB                             */
                                     /*A:輸入,Q:QBE-查詢,U:更改,R:取消,C:複製,*/
                                     /*O:QBE-印表,B:單身處理                  */
zz05        varchar2(1),             /*打印选择条件否                         */
                                     /*列印選擇條件否                         */
                                     /*本欄位僅對報表有效, 若設為 'Y', 則於報表*/
                                     /*結束時列印ＱＢＥ選擇條件               */
zz06        varchar2(1),             /*报表档附加档名                         */
                                     /*報表檔附加檔名(1).out(2)變動           */
                                     /*變動為列印次數                         */
zz07        number(5),               /*延后打印次数                           */
                                     /*延後列印次數                           */
                                     /*本欄位將於報表延後列印時賦予為系統執行檔*/
                                     /*附加檔名,並自動更新之.                 */
                                     /*Ex:若本欄位為43,則產生執行檔:sssrnnn.43c*/
zz08        varchar2(60),            /*UNIX 系统运行指令                      */
                                     /*UNIX 系統執行指令                      */
                                     /*   例：fglgo $SYS/4gi/progcode         */
zz09        date,                    /*设计日期                               */
                                     /*設計日期                               */
zz10        varchar2(10),            /*程序类型-1                             */
                                     /*程式群組名稱 關連於 gaw01              */
zz11        varchar2(4),             /*程序类型-2                             */
                                     /*程式類別-2                             */
zz12        varchar2(4),             /*程序类型-3                             */
                                     /*程式類別-3                             */
zz13        varchar2(1),             /*可否于建档作业更改索引字段             */
                                     /*可否於建檔作業更改索引欄位資料(KEY)    */
                                     /*(Y/N), 本欄位僅對建檔作業有效.         */
zz14        varchar2(1),             /*报表类型                               */
zz15        varchar2(1),             /*是否传递帐套                           */
                                     /*是否傳遞帳別(Y/N) (For agl system)     */
zz16        number(5),               /*当前报表打印次数                       */
                                     /*目前報表列印次數                       */
                                     /*本欄位將於報表列印時賦予為報表檔附加檔名*/
                                     /*並自動更新之.                          */
                                     /*Ex:若本欄位為43,則產生報表檔:sssrnnn.43r*/
zz17        number(5),               /*报表宽度                               */
                                     /*報表寬度 (79/132)                      */
zz18        varchar2(1),             /*基本用户资料权限                       */
                                     /*基本使用者資料權限                     */
                                     /*設定使用者對非自己資料之(查詢/更改/取消)*/
                                     /*處理權限, 說明如下:                    */
                                     /*         查詢     更改     取消        */
                                     /*    0:    Y        Y        Y          */
                                     /*    1:    Y        Y        N          */
                                     /*    2:    Y        N        Y          */
                                     /*    3:    Y        N        N          */
                                     /*    4:    N        N        N          */
zz19        varchar2(1),             /*基本部门资料权限                       */
                                     /*基本部門資料權限                       */
                                     /*設定使用者對非部門資料之(查詢/更改/取消)*/
                                     /*處理權限, 說明如下:                    */
                                     /*         查詢     更改     取消        */
                                     /*    0:    Y        Y        Y          */
                                     /*    1:    Y        Y        N          */
                                     /*    2:    Y        N        Y          */
                                     /*    3:    Y        N        N          */
                                     /*    4:    N        N        N          */
zz21        varchar2(80),            /*固定打印条件                           */
                                     /*固定列印條件                           */
zz22        varchar2(1),             /*固定打印方式                           */
                                     /*固定列印方式                           */
zz23        varchar2(1),             /*ISOLATION Mode                         */
                                     /*1.Dirty read 2.Committed read          */
zz24        varchar2(1),             /*Default Wait seconds (0-9)             */
zz25        varchar2(1),             /*Set explain on (Y/N)                   */
zz26        varchar2(1),             /*是否需要将错误信息写入记录             */
zz27        varchar2(20),            /*Windows Style                          */
zzuser      varchar2(10),            /*OWNER                                  */
zzgrup      varchar2(10),            /*GROUP                                  */
zzmodu      varchar2(10),            /*MODIFY USER                            */
zzdate      date,                    /*MODIFY DATE                            */
zz28        varchar2(1),             /*处理闲置连线方式                       */
zz29        varchar2(1),             /*警告信息                               */
zz30        number(5),               /*闲置时间 (秒)                          */
zz31        varchar2(255),           /*No Use                                 */
zz011       varchar2(10),            /*模组代码                               */
zz32        varchar2(1),             /*No Use                                 */
zzoriu      varchar2(10),            /*资料建立者                             */
zzorig      varchar2(10)             /*资料建立部门                           */
);

alter table zz_file add  constraint zz_pk primary key  (zz01) enable validate;
grant select on zz_file to tiptopgp;
grant update on zz_file to tiptopgp;
grant delete on zz_file to tiptopgp;
grant insert on zz_file to tiptopgp;
grant index on zz_file to public;
grant select on zz_file to ods;
