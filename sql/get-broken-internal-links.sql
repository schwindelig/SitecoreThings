-- Returns all Fields that contain <link linktype="internal" /> as value.
-- These kind of values usually break the Sitecore Link DB rebuild (System.FormatException)
select * from dbo.Fields where Value = '<link linktype="internal" />'