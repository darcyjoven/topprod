/*
================================================================================
檔案代號:bxz_file
檔案名稱:保税系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table bxz_file
(
bxz00       varchar2(1) NOT NULL,    /*KEY VALUE = '0'                        */
bxz01       varchar2(1),             /*当前保税系统是否可开放用户             */
                                     /*目前保稅系統是否可開放使用者使用(Y/N)? */
                                     /*Y: 正常使用                            */
                                     /*N: 僅供使用者列印查詢                  */
                                     /*     不可作資料的新增,修改,查詢,刪除   */
bxz02       varchar2(1),             /*No Use                                 */
bxz03       varchar2(1),             /*No Use                                 */
bxz04       varchar2(1),             /*No Use                                 */
bxz05       number(20,6),            /*预估税款保证金                         */
bxz06       number(5),               /*现行结算年度                           */
bxz07       date,                    /*现行结算起始日期                       */
bxz08       date,                    /*现行结算截止日期                       */
bxz09       date,                    /*关帐日期                               */
bxz10       varchar2(4),             /*No Use                                 */
bxz11       varchar2(10),            /*原料仓缺省仓库编号                     */
                                     /*原料倉預設倉庫編號 No.+024             */
bxz12       varchar2(10),            /*半成仓缺省仓库编号                     */
                                     /*半成倉預設倉庫編號 No.+024             */
bxz13       varchar2(10),            /*成品仓缺省仓库编号                     */
                                     /*成品倉預設倉庫編號 No.+024             */
bxz14       varchar2(10),            /*报废仓缺省仓库编号                     */
                                     /*報廢倉預設倉庫編號 No.+024             */
bxz15       varchar2(1),             /*No Use                                 */
bxz16       varchar2(1),             /*No Use                                 */
bxz21       varchar2(10),            /*自保/课税区录入登记簿来源原            */
bxz22       varchar2(4),             /*No Use                                 */
bxz23       varchar2(10),            /*输往保税厂返工出口登记簿来             */
bxz24       varchar2(10),            /*内销登记簿来源原因码                   */
bxz25       varchar2(10),            /*内销保税原因代码                       */
bxz26       varchar2(10),            /*外销保税原因代码                       */
bxz27       varchar2(4),             /*No Use                                 */
bxz28       varchar2(4),             /*No Use                                 */
bxz29       varchar2(4),             /*No Use                                 */
bxz99       varchar2(1),             /*No Use                                 */
bxz100      varchar2(80),            /*保税监管单位                           */
bxz101      varchar2(10),            /*海关监管编号                           */
bxz102      varchar2(20),            /*保税类型                               */
bxz103      varchar2(10),            /*外运原因编号                           */
bxz104      varchar2(10),            /*负责人                                 */
bxz105      varchar2(10)             /*保税业务人员                           */
);

alter table bxz_file add  constraint bxz_pk primary key  (bxz00) enable validate;
grant select on bxz_file to tiptopgp;
grant update on bxz_file to tiptopgp;
grant delete on bxz_file to tiptopgp;
grant insert on bxz_file to tiptopgp;
grant index on bxz_file to public;
grant select on bxz_file to ods;
