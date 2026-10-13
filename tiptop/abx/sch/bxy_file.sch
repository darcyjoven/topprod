/*
================================================================================
檔案代號:bxy_file
檔案名稱:保税单别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bxy_file
(
bxy01       varchar2(5) NOT NULL,    /*单别                                   */
bxy02       varchar2(80),            /*单据名称                               */
bxy03       varchar2(1),             /*原始单据撷取前是否需要审核             */
                                     /*Y/N                                    */
bxy04       varchar2(1),             /*单据性质                               */
                                     /*單據性質: 0. 其他                      */
                                     /*                  1. 驗收入庫單        */
                                     /*                  2. 內銷出貨單        */
                                     /*                  3.外銷出貨單         */
                                     /*                  4. 收貨單            */
bxy05       varchar2(10),            /*保税原因代码                           */
bxy06       varchar2(1),             /*自行编号否                             */
bxy07       varchar2(1)              /*编号方式                               */
);

alter table bxy_file add  constraint bxy_pk primary key  (bxy01) enable validate;
grant select on bxy_file to tiptopgp;
grant update on bxy_file to tiptopgp;
grant delete on bxy_file to tiptopgp;
grant insert on bxy_file to tiptopgp;
grant index on bxy_file to public;
grant select on bxy_file to ods;
