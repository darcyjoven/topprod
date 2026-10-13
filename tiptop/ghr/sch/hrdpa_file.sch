/*
================================================================================
檔案代號:hrdpa_file
檔案名稱:申请薪资级别信息
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrdpa_file
(
hrdpa01     varchar2(10) NOT NULL,   /*流水码                                 */
hrdpa02     varchar2(20) NOT NULL,   /*薪资等级编码                           */
hrdpa03     varchar2(20),            /*薪资等级档                             */
hrdpa04     varchar2(20),            /*薪资等级栏                             */
hrdpa05     number(15,2),            /*定级金额                               */
hrdpa06     date NOT NULL,           /*生效日期                               */
hrdpa07     date,                    /*失效日期                               */
hrdpa08     varchar2(255),           /*备注                                   */
hrdpaud01   varchar2(255),
hrdpaud02   varchar2(40),
hrdpaud03   varchar2(40),
hrdpaud04   varchar2(40),
hrdpaud05   varchar2(40),
hrdpaud06   varchar2(40),
hrdpaud07   number(15,3),
hrdpaud08   number(15,3),
hrdpaud09   number(15,3),
hrdpaud10   number(10),
hrdpaud11   number(10),
hrdpaud12   number(10),
hrdpaud13   date,
hrdpaud14   date,
hrdpaud15   date
);

alter table hrdpa_file add  constraint hrdpa_pk primary key  (hrdpa01,hrdpa02,hrdpa06) enable validate;
grant select on hrdpa_file to tiptopgp;
grant update on hrdpa_file to tiptopgp;
grant delete on hrdpa_file to tiptopgp;
grant insert on hrdpa_file to tiptopgp;
grant index on hrdpa_file to public;
grant select on hrdpa_file to ods;
