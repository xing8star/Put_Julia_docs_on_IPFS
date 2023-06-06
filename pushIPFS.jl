using IPFS

docsname="docs"
ipfs_docsname="julia_docs"

if !isdir(docsname) mkdir(docsname) end

all_docs=readdir(docsname,join=true)

if length(all_docs)==0 exit() end

IPFS.daemon()

if !(ipfs_docsname in ipfs"ls")
    ipfs"mkdir julia_docs"
else
    ipfs"rm julia_docs"
    ipfs"mkdir julia_docs"
end
ipfs"cd julia_docs"

for i in all_docs
    IPFS.add(i,recursive=true)
end

result_link=ipfs"stat /julia_docs"

open("index.html","w") do io
    write(io,"""<a href="http://$(toLocalUrl(result_link))">$ipfs_docsname</a>""")
end

open("README.md","a") do io
    write(io,"\n\n$(IPFS.getcid(result_link))")
end

ipfs"shutdown"
