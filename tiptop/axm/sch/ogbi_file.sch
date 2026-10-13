/*
================================================================================
檔案代號:ogbi_file
檔案名稱:出货单单身档(行业别档)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogbi_file
(
ogbi01      varchar2(20) DEFAULT ' ' NOT NULL, /*出货单号*/
ogbi03      number(5) DEFAULT '0' NOT NULL, /*项次*/
ogbiicd01   varchar2(1),             /*转仓                                   */
ogbiicd02   number(9,4),             /*备品比率                               */
ogbiicd03   varchar2(1),             /*类型                                   */
ogbiicd04   varchar2(20),            /*Tape Reel                              */
ogbiplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
ogbilegal   varchar2(10) NOT NULL,   /*所属法人                               */
ogbiicd028  varchar2(80),            /*DATECODE                               */
ogbiicd029  varchar2(24),            /*母批                                   */
ogbislk01   varchar2(40),            /*款号料件编号                           */
ogbislk02   number(5),               /*款號項次                               */
ogbiicd07   varchar2(10)             /*End User                               */
);

alter table ogbi_file add  constraint ogbi_pk primary key  (ogbi01,ogbi03) enable validate;
grant select on ogbi_file to tiptopgp;
grant update on ogbi_file to tiptopgp;
grant delete on ogbi_file to tiptopgp;
grant insert on ogbi_file to tiptopgp;
grant index on ogbi_file to public;
grant select on ogbi_file to ods;
