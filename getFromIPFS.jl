using IPFS

docsname="docs"
ipfs_docsname="julia_docs"


IPFS.daemon()

if !(ipfs_docsname in ipfs"ls")
    ipfs"mkdir julia_docs"
end

result_link=ipfs"stat /julia_docs"

IPFS.get(result_link)

ipfs"shutdown"
