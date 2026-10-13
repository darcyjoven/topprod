/*
================================================================================
檔案代號:adm_file
檔案名稱:派車單其它托運物品檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adm_file
(
adm01       varchar2(16),            /*派車單單號                             */
adm02       number(5),               /*項次                                   */
adm03       varchar2(1),             /*類別                                   */
adm04       number(5),               /*件數                                   */
adm05       varchar2(20),            /*說明                                   */
adm06       varchar2(8),             /*委托人                                 */
adm07       varchar2(14),            /*收件單位                               */
adm08       varchar2(14)             /*收件人                                 */
);

create unique index adm_01 on adm_file (adm01,adm02);
grant select on adm_file to public;
grant index on adm_file to public;
grant update on adm_file to public;
grant delete on adm_file to public;
grant insert on adm_file to public;
