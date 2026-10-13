/*
================================================================================
檔案代號:smp_file
檔案名稱:日关账设置资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table smp_file
(
smp00       number(5) NOT NULL,      /*序号(KEY VALUE=0)                      */
smp01       varchar2(1),             /*库存日关帐(Y/N)                        */
smp011      number(5),               /*现行日期前几天关帐                     */
smp02       varchar2(1),             /*应付日关帐(Y/N)                        */
smp021      number(5),               /*现行日期前几天关帐                     */
smp03       varchar2(1),             /*应收日关帐(Y/N)                        */
smp031      number(5),               /*现行日期前几天关帐                     */
smp04       varchar2(1),             /*票据日关帐(Y/N)                        */
smp041      number(5),               /*现行日期前几天关帐                     */
smp05       varchar2(1),             /*固资财签日关帐(Y/N)                    */
smp051      number(5),               /*现行日期前几天关帐                     */
smp06       varchar2(1),             /*固资税签日关帐(Y/N)                    */
smp061      number(5),               /*现行日期前几天关帐                     */
smp07       varchar2(1)              /*总帐日关帐(Y/N)                        */
);

alter table smp_file add  constraint smp_pk primary key  (smp00) enable validate;
grant select on smp_file to tiptopgp;
grant update on smp_file to tiptopgp;
grant delete on smp_file to tiptopgp;
grant insert on smp_file to tiptopgp;
grant index on smp_file to public;
grant select on smp_file to ods;
