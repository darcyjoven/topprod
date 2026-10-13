/*
================================================================================
檔案代號:zy_file
檔案名稱:权限设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zy_file
(
zy01        varchar2(10) NOT NULL,   /*权限类型                               */
                                     /*權限類別                               */
zy02        varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*程式代號,  (program code)              */
zy03        varchar2(3000),          /*允许运行功能                           */
                                     /*允許執行功能                           */
                                     /*設定該使用者對本程式所可執行的功能     */
                                     /*Ex:AURQCOB                             */
                                     /*A:輸入,Q:QBE-查詢,U:更改,R:取消,C:複製,*/
                                     /*O:QBE-印表,B:單身處理                  */
zy04        varchar2(1),             /*用户资料权限                           */
                                     /*使用者資料權限                         */
                                     /*設定使用者對非自己資料之(查詢/更改/取消)*/
                                     /*處理權限, 說明如下:                    */
                                     /*         查詢     更改     取消        */
                                     /*    0:    Y        Y        Y          */
                                     /*    1:    Y        Y        N          */
                                     /*    2:    Y        N        Y          */
                                     /*    3:    Y        N        N          */
                                     /*    4:    N        N        N          */
zy05        varchar2(1),             /*部门资料权限                           */
                                     /*部門資料權限                           */
                                     /*設定使用者對非部門資料之(查詢/更改/取消)*/
                                     /*處理權限, 說明如下:                    */
                                     /*         查詢     更改     取消        */
                                     /*    0:    Y        Y        Y          */
                                     /*    1:    Y        Y        N          */
                                     /*    2:    Y        N        Y          */
                                     /*    3:    Y        N        N          */
                                     /*    4:    N        N        N          */
zy06        varchar2(20),            /*用户允许印表方式                       */
                                     /*使用者允許印表方式                     */
                                     /*以何種方式處理報表檔                   */
                                     /*(1) 系統印表機-1                       */
                                     /*(2) 系統印表機-2                       */
                                     /*(3) 系統印表機-3                       */
                                     /*(S) 其它系統印表機-4至9                */
                                     /*(L) 終端機印表 by p000                 */
                                     /*(D) 畫面顯示 by pg                     */
                                     /*(V) 編輯報表檔(viwe)                   */
                                     /*(X) ($LPX)                             */
                                     /*(F) 傳真                               */
zyuser      varchar2(10),            /*OWNER                                  */
zygrup      varchar2(10),            /*GROUP                                  */
zymodu      varchar2(10),            /*USER                                   */
zydate      date,                    /*MODIFY DATE                            */
zy07        varchar2(1),             /*程序单身处理权限                       */
zyorig      varchar2(10),            /*资料建立部门                           */
zyoriu      varchar2(10)             /*资料建立者                             */
);

create        index zy_02 on zy_file (zy02);
alter table zy_file add  constraint zy_pk primary key  (zy01,zy02) enable validate;
grant select on zy_file to tiptopgp;
grant update on zy_file to tiptopgp;
grant delete on zy_file to tiptopgp;
grant insert on zy_file to tiptopgp;
grant index on zy_file to public;
grant select on zy_file to ods;
