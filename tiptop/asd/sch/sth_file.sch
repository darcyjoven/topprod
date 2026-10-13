/*
================================================================================
檔案代號:sth_file
檔案名稱:每月工单投入人工,制费明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sth_file
(
sth01       number(5),               /*年度                                   */
sth02       number(5),               /*月份                                   */
sth03       varchar2(20),            /*工单号码                               */
                                     /*工單號碼                               */
sth04       number(20,6),            /*投入人工                               */
sth05       number(20,6),            /*投入制费一                             */
                                     /*投入製費一                             */
sth06       number(20,6),            /*投入制费二                             */
                                     /*投入製費二                             */
sth07       number(20,6),            /*投入加工费用                           */
                                     /*投入加工費用                           */
sthplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sthlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index sth_01 on sth_file (sth01,sth02,sth03);
grant select on sth_file to tiptopgp;
grant update on sth_file to tiptopgp;
grant delete on sth_file to tiptopgp;
grant insert on sth_file to tiptopgp;
grant index on sth_file to public;
grant select on sth_file to ods;
