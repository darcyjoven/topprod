/*
================================================================================
檔案代號:pmni_file
檔案名稱:采购单单身档(行业别档)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmni_file
(
pmni01      varchar2(20) DEFAULT ' ' NOT NULL, /*采购单号*/
pmni02      number(5) DEFAULT '0' NOT NULL, /*采购项次*/
pmniicd01   varchar2(20),            /*订单单号                               */
pmniicd02   number(5),               /*订单项次                               */
pmniicd03   varchar2(10),            /*Icd作业编号                            */
pmniicd04   varchar2(1),             /*New Code                               */
pmniicd05   varchar2(1),             /*Low Yield                              */
pmniicd06   varchar2(1),             /*Metal Layer                            */
pmniicd07   number(15,3),            /*FST片数                                */
pmniicd08   varchar2(1),             /*Multi Die                              */
pmniicd09   number(15,3),            /*Reference Die                          */
pmniicd10   varchar2(1),             /*已转完采购单否                         */
pmniicd11   varchar2(80),            /*Datecode                               */
pmniicd12   varchar2(10),            /*Wafer Site                             */
pmniicd13   number(15,3),            /*已转wafer start采购单数量              */
pmniicd14   varchar2(40),            /*内编母体料号                           */
pmniicd15   varchar2(40),            /*最终料号                               */
pmniicd16   varchar2(24),            /*母批                                   */
pmniicd17   varchar2(10),            /*Wafer厂商                              */
pmniicd18   varchar2(10),            /*下阶厂商                               */
pmnislk01   varchar2(20),            /*制单号                                 */
pmniplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
pmnilegal   varchar2(10) NOT NULL,   /*所属法人                               */
pmnislk02   varchar2(40),            /*款号                                   */
pmnislk03   number(5)                /*款號項次                               */
);

alter table pmni_file add  constraint pmni_pk primary key  (pmni01,pmni02) enable validate;
grant select on pmni_file to tiptopgp;
grant update on pmni_file to tiptopgp;
grant delete on pmni_file to tiptopgp;
grant insert on pmni_file to tiptopgp;
grant index on pmni_file to public;
grant select on pmni_file to ods;
